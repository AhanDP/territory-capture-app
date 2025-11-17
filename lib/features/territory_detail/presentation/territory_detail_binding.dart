import 'package:get/get.dart';
import '../../territory/domain/territory_repository.dart';
import 'territory_detail_controller.dart';

class TerritoryDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TerritoryDetailController(repository: Get.find<TerritoryRepository>()));
  }
}