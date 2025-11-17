import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import 'package:territory_capture/shared/utility/extension.dart';
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

    return Scaffold(
      body: Stack(
        children: [
          Obx(() {
            // initial camera - center can be 0,0 until map ready
            return GoogleMap(
              initialCameraPosition: const CameraPosition(target: LatLng(0,0), zoom: 16),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: controller.polylines.toSet(),
              polygons: controller.polygon.value != null ? {controller.polygon.value!} : {},
              onMapCreated: (ctrl) => controller.mapController.value = ctrl,
            );
          }),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _topBar(auth),
                  const Spacer(),
                  _controls(controller, auth),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar(LoginController auth) {
    return Row(
      children: [
        CircleAvatar(backgroundColor: context.colors.surface, child: Icon(Icons.person, color: context.colors.primary)),
        const SizedBox(width:12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello,', style: TextStyle(color: context.colors.onSecondary)),
              Obx(() => Text(auth.user.value?.displayName ?? 'Guest', style: const TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        IconButton(onPressed: () => auth.signOut(), icon: const Icon(Icons.logout))
      ],
    );
  }

  Widget _controls(MapCaptureController controller, LoginController auth) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal:12, vertical:8),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Obx(() => Row(
            children: [
              Icon(Icons.directions_walk, color: context.colors.primary),
              const SizedBox(width:8),
              Text('${(controller.distanceMeters.value / 1000).toStringAsFixed(3)} km'),
              const Spacer(),
              Text('Pts: ${controller.points.length}'),
            ],
          )),
        ),
        const SizedBox(height:12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () => controller.startCapture(),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start'),
              style: ElevatedButton.styleFrom(backgroundColor: context.colors.primary),
            ),
            ElevatedButton.icon(
              onPressed: () => controller.pauseCapture(),
              icon: const Icon(Icons.pause),
              label: const Text('Pause'),
            ),
            ElevatedButton.icon(
              onPressed: () => controller.resumeCapture(),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Resume'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                final userId = auth.userId;
                if (userId != null) controller.finishCapture(userId);
              },
              icon: const Icon(Icons.check),
              label: const Text('Finish'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            ),
            ElevatedButton.icon(
              onPressed: () => controller.discardCapture(),
              icon: const Icon(Icons.delete),
              label: const Text('Discard'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            ),
          ],
        )
      ],
    );
  }
}