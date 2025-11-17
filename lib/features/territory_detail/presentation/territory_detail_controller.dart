import 'dart:io';
import 'dart:typed_data';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import '../../../shared/widgets/app_dialogs.dart';
import '../../territory/domain/territory_entity.dart';
import '../../territory/domain/territory_repository.dart';

class TerritoryDetailController extends GetxController {
  final TerritoryRepository repository;
  TerritoryDetailController({required this.repository});

  final territory = Rxn<Territory>();
  final isLoading = false.obs;

  Future<void> loadById(String id) async {
    try {
      isLoading.value = true;
      final t = await repository.getTerritoryById(id);
      if (t != null) {
        territory.value = t;
      } else {
        AppDialogs.instance.showToast('Territory not found');
      }
    } catch (e) {
      AppDialogs.instance.showToast('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> takeScreenshot(ScreenshotController screenshotController) async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      int sdkInt = 33;

      if (Platform.isAndroid) {
        AndroidDeviceInfo android = await deviceInfo.androidInfo;
        sdkInt = android.version.sdkInt;
      }

      if (Platform.isAndroid && sdkInt < 33) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          AppDialogs.instance.showError("Storage permission denied");
          return;
        }
      }
      Uint8List? image = await screenshotController.capture();
      if (image == null) {
        AppDialogs.instance.showError("Failed to capture screenshot");
        return;
      }

      final result = await ImageGallerySaverPlus.saveImage(
        image,
        name: "territory_${DateTime.now().millisecondsSinceEpoch}",
        quality: 100,
      );

      if (result["isSuccess"] == true || result["success"] == true) {
        AppDialogs.instance.showSuccess("Screenshot saved to Gallery!");
      } else {
        AppDialogs.instance.showError("Failed to save screenshot");
      }

    } catch (e) {
      AppDialogs.instance.showError("Error capturing screenshot: $e");
    }
  }
}