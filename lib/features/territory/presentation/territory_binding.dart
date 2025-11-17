import 'package:get/get.dart';
import '../domain/territory_repository.dart';
import 'territory_controller.dart';

class TerritoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TerritoryController(repository: Get.find<TerritoryRepository>()));
  }
}