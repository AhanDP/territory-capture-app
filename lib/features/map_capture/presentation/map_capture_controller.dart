import 'dart:async';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/widgets/app_dialogs.dart';
import '../../territory/domain/territory_entity.dart';
import '../../territory/domain/territory_repository.dart';
import '../../territory/presentation/territory_controller.dart';

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

  final markers = <Marker>{}.obs;

  StreamSubscription<Position>? _positionSub;
  late String _currentId;
  final isLocationReady = false.obs;
  Position? pos;
  static const String startMarkerId = "start_marker";
  static const String movingMarkerId = "moving_marker";

  @override
  Future<void> onInit() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        AppDialogs.instance.showError(
          title: "Permission Needed",
          "Location permission is required to capture territory.\n\nPlease enable it in settings.",
          onOkPressed: () {
            Geolocator.openAppSettings(); // ← Opens settings
          },
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AppDialogs.instance.showError(
        title: "Permission Blocked",
        "You permanently denied location permission.\n\nPlease enable it from settings.",
        onOkPressed: () {
          Geolocator.openAppSettings();
        },
      );
      return;
    }

    if (!await Geolocator.isLocationServiceEnabled()) {
      AppDialogs.instance.showError(
        title: "GPS Disabled",
        "Please turn ON Location Services",
        onOkPressed: () {
          Geolocator.openLocationSettings();
        },
      );
      return;
    }
    pos = await Geolocator.getCurrentPosition();
    isLocationReady.value = true;

    if (await Geolocator.isLocationServiceEnabled() == false) {
      AppDialogs.instance.showError(title: 'Location off', 'Please enable location services');
      return;
    }

    pos = await Geolocator.getCurrentPosition();
    isLocationReady.value = true;
    super.onInit();
  }

  @override
  void onClose() {
    _positionSub?.cancel();
    super.onClose();
  }

  Future<void> moveToCurrentLocation() async {
    final pos = await Geolocator.getCurrentPosition();
    final ctrl = mapController.value;
    if (ctrl == null) return;

    await ctrl.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 17,
        ),
      ),
    );
  }

  Future<void> startCapture() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        AppDialogs.instance.showError(
          title: "Permission Needed",
          "Location permission is required to capture territory.\n\nPlease enable it in settings.",
          onOkPressed: () {
            Geolocator.openAppSettings(); // ← Opens settings
          },
        );
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      AppDialogs.instance.showError(
        title: "Permission Blocked",
        "You permanently denied location permission.\n\nPlease enable it from settings.",
        onOkPressed: () {
          Geolocator.openAppSettings();
        },
      );
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      AppDialogs.instance.showError(
        title: "GPS Disabled",
        "Please turn ON Location Services",
        onOkPressed: () {
          Geolocator.openLocationSettings();
        },
      );
      return;
    }

    pos = await Geolocator.getCurrentPosition();
    isLocationReady.value = true;

    _currentId = const Uuid().v4();

    points.clear();
    polylines.clear();
    markers.clear();
    distanceMeters.value = 0.0;

    captureState.value = CaptureState.capturing;

    markers.add(
      Marker(
        markerId: const MarkerId("start"),
        position: LatLng(pos!.latitude, pos!.longitude),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: "Start"),
      ),
    );

    final settings = LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    );

    _positionSub = Geolocator.getPositionStream(locationSettings: settings)
        .listen(_onNewPosition);
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
    markers.clear();
    distanceMeters.value = 0.0;
    AppDialogs.instance.showToast('Capture discarded');
  }

  void _onNewPosition(Position pos) {
    final newPoint = LatLngPoint(
      lat: pos.latitude,
      lng: pos.longitude,
      timestamp: DateTime.now(),
    );

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
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  Future<void> finishCapture(String userId) async {
    if (points.length < 3) {
      AppDialogs.instance.showToast('Walk a little more to capture territory');
      return;
    }

    try {
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

      polygon.value = Polygon(
        polygonId: PolygonId(_currentId),
        points: closed.map((p) => LatLng(p.lat, p.lng)).toList(),
        fillColor: const Color.fromARGB(80, 33, 150, 243),
        strokeColor: AppColors.primary,
        strokeWidth: 2,
      );

      captureState.value = CaptureState.idle;
      _positionSub?.cancel();

      await repository.saveTerritory(territory);

      final tc = Get.find<TerritoryController>();
      tc.loadUserTerritories(userId);

      AppDialogs.instance.showSuccess('Territory saved successfully');
    } catch (e) {
      AppDialogs.instance.showError(title: "Error", "Failed to save territory");
    }
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

    return (total.abs() / 2.0) * R * R;
  }
}