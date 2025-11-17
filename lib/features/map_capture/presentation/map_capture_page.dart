import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import 'package:territory_capture/shared/utility/extension.dart';
import 'package:territory_capture/shared/widgets/loader.dart';
import '../../login/presentation/login_controller.dart';
import 'map_capture_controller.dart';

class MapCapturePage extends StatefulWidget {
  const MapCapturePage({super.key});

  @override
  State<MapCapturePage> createState() => _MapCapturePageState();
}

class _MapCapturePageState extends State<MapCapturePage> {
  @override
  Widget build(BuildContext context) {
    final MapCaptureController controller = Get.find();
    final LoginController auth = Get.find();

    return Padding(
      padding: .all(16),
      child: Column(
        children: [
          Obx(() {
            return Container(
              height: MediaQuery.of(context).size.height * 0.55,
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
                child: !controller.isLocationReady.value ? const Loader() : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(controller.pos!.latitude, controller.pos!.longitude),
                    zoom: 16,
                  ),
                  zoomControlsEnabled: false,
                  zoomGesturesEnabled: true,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: controller.markers.toSet(),
                  polylines: controller.polylines.toSet(),
                  polygons: controller.polygon.value != null ? {controller.polygon.value!} : {},
                  onMapCreated: (ctrl) {
                    controller.mapController.value = ctrl;
                    controller.moveToCurrentLocation();
                  },
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          _controls(controller, auth),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _controls(MapCaptureController controller, LoginController auth) {
    return Obx(() {
      final state = controller.captureState.value;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.directions_walk, color: context.colors.primary),
                const SizedBox(width: 8),
                Text(
                  '${(controller.distanceMeters.value / 1000).toStringAsFixed(3)} km',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Spacer(),
                Text("Pts: ${controller.points.length}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          const SizedBox(height: 20),
          if (state == CaptureState.idle)
            _btnFullWidth(
              color: context.colors.primary,
              icon: Icons.play_arrow,
              text: 'Start Capture',
              onTap: controller.startCapture,
            ),

          if (state == CaptureState.capturing)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 12,
              children: [
                _smallBtn(Icons.pause, 'Pause', controller.pauseCapture),
                _smallBtn(Icons.check, 'Finish', () {
                  final id = auth.userId;
                  if (id != null) controller.finishCapture(id);
                }, color: Colors.green),
                _smallBtn(Icons.delete, 'Discard', controller.discardCapture,
                    color: Colors.red),
              ],
            ),

          if (state == CaptureState.paused)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 12,
              children: [
                _smallBtn(Icons.play_arrow, 'Resume', controller.resumeCapture),
                _smallBtn(Icons.check, 'Finish', () {
                  final id = auth.userId;
                  if (id != null) controller.finishCapture(id);
                }, color: Colors.green),
                _smallBtn(Icons.delete, 'Discard', controller.discardCapture,
                    color: Colors.red),
              ],
            ),
        ],
      );
    });
  }

  Widget _btnFullWidth({required Color color, required IconData icon, required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _smallBtn(IconData icon, String text, VoidCallback onTap, {Color color = Colors.black87}) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(text, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

}