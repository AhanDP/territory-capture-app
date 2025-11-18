import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';

import '../../../shared/theme/app_colors.dart';
import '../../../shared/utility/extension.dart';
import 'territory_detail_controller.dart';

class TerritoryDetailPage extends StatelessWidget {
  const TerritoryDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScreenshotController screenshotController = ScreenshotController();
    final TerritoryDetailController controller = Get.find();
    final String id = Get.arguments ?? '';
    if (id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadById(id);
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Territory Detail'), centerTitle: true,),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await controller.takeScreenshot(screenshotController);
        },
        icon: const Icon(Icons.camera_alt, color: Colors.white),
        label: const Text("Save Screenshot", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          child: Obx(() {
            if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
            final t = controller.territory.value;
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
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: .all(16),
                  decoration: BoxDecoration(
                    borderRadius: .circular(20),
                    border: Border.symmetric(vertical: BorderSide(color: AppColors.primary, width: 3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: .circular(20),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(target: polygon.points.first, zoom: 16),
                      zoomGesturesEnabled: true,
                      zoomControlsEnabled: false,
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      polygons: {polygon},
                      onMapCreated: (controller) {
                        Future.delayed(const Duration(milliseconds: 400), () {
                          controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 40));
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  margin: .all(16),
                  padding: .all(16),
                  decoration: BoxDecoration(
                    borderRadius: .circular(20),
                    border: Border.symmetric(vertical: BorderSide(color: AppColors.primary, width: 3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        Text('Distance: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: context.colors.onSecondary)),
                        Text('${t.distanceMeters.toStringAsFixed(2)} m', style: TextStyle(color: context.colors.onPrimary, fontSize: 18, fontWeight: FontWeight.w700),),
                      ]),
                      const SizedBox(height:8),
                      Row(children: [
                        Text('Area: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: context.colors.onSecondary)),
                        Text('${(t.areaSqMeters ?? 0).toStringAsFixed(2)} m²', style: TextStyle(color: context.colors.onPrimary, fontSize: 18, fontWeight: FontWeight.w700),),
                      ]),
                      const SizedBox(height:8),
                      Row(children: [
                        Text('Points: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: context.colors.onSecondary)),
                        Text('${t.points.length}', style: TextStyle(color: context.colors.onPrimary, fontSize: 18, fontWeight: FontWeight.w700),),
                      ]),
                      const SizedBox(height:8),
                      Row(children: [
                        Text('Created: ', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: context.colors.onSecondary)),
                        Text(DateFormat.yMMMd().add_jm().format(t.createdAt), style: TextStyle(color: context.colors.onPrimary, fontSize: 18, fontWeight: FontWeight.w700),),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(height: 80)
              ],
            );
          }),
        ),
      ),
    );
  }
}