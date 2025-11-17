import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import 'territory_detail_controller.dart';

class TerritoryDetailPage extends StatelessWidget {
  const TerritoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TerritoryDetailController c = Get.find();
    final String id = Get.arguments ?? '';
    if (id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        c.loadById(id);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Territory Detail')),
      body: Obx(() {
        if (c.isLoading.value) return const Center(child: CircularProgressIndicator());
        final t = c.territory.value;
        if (t == null) return const Center(child: Text('Not found'));

        final polygon = Polygon(
          polygonId: PolygonId(t.id),
          points: t.points.map((p) => LatLng(p.lat, p.lng)).toList(),
          fillColor: const Color.fromARGB(80, 33, 150, 243),
          strokeWidth: 2,
          strokeColor: Colors.blue,
        );

        final bounds = LatLngBounds(
          southwest: LatLng(
            t.points.map((p) => p.lat).reduce((a, b) => a < b ? a : b),
            t.points.map((p) => p.lng).reduce((a, b) => a < b ? a : b),
          ),
          northeast: LatLng(
            t.points.map((p) => p.lat).reduce((a, b) => a > b ? a : b),
            t.points.map((p) => p.lng).reduce((a, b) => a > b ? a : b),
          ),
        );

        return Column(
          children: [
            Expanded(
              flex: 2,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: polygon.points.first, zoom: 16),
                polygons: {polygon},
                onMapCreated: (controller) {
                  // auto fit
                  Future.delayed(const Duration(milliseconds: 400), () {
                    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
                  });
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(children: [
                      Text('Distance: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${t.distanceMeters.toStringAsFixed(2)} m'),
                    ]),
                    const SizedBox(height:8),
                    Row(children: [
                      Text('Area: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${(t.areaSqMeters ?? 0).toStringAsFixed(2)} m²'),
                    ]),
                    const SizedBox(height:8),
                    Row(children: [
                      Text('Points: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${t.points.length}'),
                    ]),
                    const SizedBox(height:8),
                    Row(children: [
                      Text('Created: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(DateFormat.yMMMd().add_jm().format(t.createdAt)),
                    ]),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}