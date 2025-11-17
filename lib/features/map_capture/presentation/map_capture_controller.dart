import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../territory/domain/territory_entity.dart';
import '../../territory/domain/territory_repository.dart';

enum CaptureState { idle, capturing, paused }

class MapCaptureController extends GetxController {
  final TerritoryRepository repository;
  MapCaptureController({required this.repository});

  final Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);

  final polylines = <Polyline>{}.obs;
  final polygon = Rxn<Polygon>();
  final captureState = CaptureState.idle.obs;
  final points = <LatLngPoint>[].obs;
  final distanceMeters = 0.0.obs;

  StreamSubscription<Position>? _positionSub;
  late String _currentId;

  @override
  void onClose() {
    _positionSub?.cancel();
    super.onClose();
  }

  Future<void> startCapture() async {
    _currentId = const Uuid().v4();
    points.clear();
    distanceMeters.value = 0.0;

    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final r = await Geolocator.requestPermission();
      if (r == LocationPermission.denied) {
        Get.snackbar('Permission denied', 'Location permission is required');
        return;
      }
    }
    if (await Geolocator.isLocationServiceEnabled() == false) {
      Get.snackbar('Location off', 'Please enable location services');
      return;
    }

    captureState.value = CaptureState.capturing;

    final settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 4,
      timeLimit: null,
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: settings).listen((pos) {
      _onNewPosition(pos);
    });
  }

  void pauseCapture() {
    if (captureState.value == CaptureState.capturing) {
      captureState.value = CaptureState.paused;
      _positionSub?.pause();
    }
  }

  void resumeCapture() {
    if (captureState.value == CaptureState.paused) {
      captureState.value = CaptureState.capturing;
      _positionSub?.resume();
    }
  }

  void discardCapture() {
    captureState.value = CaptureState.idle;
    _positionSub?.cancel();
    points.clear();
    polylines.clear();
    polygon.value = null;
    distanceMeters.value = 0.0;
    Get.snackbar('Discarded', 'Capture discarded');
  }

  void _onNewPosition(Position pos) {
    final newPoint = LatLngPoint(lat: pos.latitude, lng: pos.longitude, timestamp: DateTime.now());
    if (points.isNotEmpty) {
      final last = points.last;
      final added = _distanceBetween(last.lat, last.lng, newPoint.lat, newPoint.lng);
      if (added > 0.5) {
        distanceMeters.value += added;
      }
    }
    points.add(newPoint);
    _updatePolyline();
    _animateCameraTo(LatLng(newPoint.lat, newPoint.lng));
  }

  void _updatePolyline() {
    final poly = Polyline(
      polylineId: const PolylineId('live_polyline'),
      points: points.map((p) => LatLng(p.lat, p.lng)).toList(),
      width: 5,
      color: AppColors.primary,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    polylines.value = {poly};
  }

  Future<void> _animateCameraTo(LatLng pos) async {
    final ctrl = mapController.value;
    if (ctrl == null) return;
    try {
      await ctrl.animateCamera(CameraUpdate.newLatLng(pos));
    } catch (_) {}
  }

  double _deg2rad(double deg) => deg * (math.pi / 180);

  double _distanceBetween(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371000;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) * math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  // On finish: close polygon, compute area, save
  Future<void> finishCapture(String userId) async {
    if (points.length < 3) {
      Get.snackbar('Too few points', 'Walk a little more to capture territory');
      return;
    }

    final closed = List<LatLngPoint>.from(points);
    if (closed.first.lat != closed.last.lat || closed.first.lng != closed.last.lng) {
      closed.add(closed.first);
    }

    final area = _computePolygonAreaMeters(closed);

    final territory = Territory(
      id: _currentId,
      userId: userId,
      createdAt: DateTime.now(),
      distanceMeters: distanceMeters.value,
      areaSqMeters: area,
      points: closed,
      polylineEncoded: null,
    );

    await repository.saveTerritory(territory);

    // show polygon
    polygon.value = Polygon(
      polygonId: PolygonId(_currentId),
      points: closed.map((p) => LatLng(p.lat, p.lng)).toList(),
      fillColor: const Color.fromARGB(80, 33, 150, 243),
      strokeColor: AppColors.primary,
      strokeWidth: 2,
    );

    captureState.value = CaptureState.idle;
    _positionSub?.cancel();

    Get.snackbar('Saved', 'Territory saved successfully');
    Get.offAllNamed('/territory_list');
  }

  double _computePolygonAreaMeters(List<LatLngPoint> pts) {
    if (pts.length < 3) return 0.0;
    final R = 6378137.0;
    double total = 0.0;
    for (var i = 0; i < pts.length - 1; i++) {
      final lat1 = _deg2rad(pts[i].lat);
      final lon1 = _deg2rad(pts[i].lng);
      final lat2 = _deg2rad(pts[i + 1].lat);
      final lon2 = _deg2rad(pts[i + 1].lng);
      total += (lon2 - lon1) * (2 + math.sin(lat1) + math.sin(lat2));
    }
    total = total.abs() / 2.0;
    return (total * R * R);
  }
}