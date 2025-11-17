import 'package:get/get.dart';
import '../../territory/domain/territory_repository.dart';
import 'map_capture_controller.dart';

class MapCaptureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MapCaptureController(repository: Get.find<TerritoryRepository>()));
  }
}
