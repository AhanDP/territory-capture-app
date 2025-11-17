import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/repositories/territory_repository_impl.dart';
import '../domain/territory_repository.dart';
import '../data/data_source/territory_data_source.dart';
import 'territory_controller.dart';

class TerritoryBinding extends Bindings {
  @override
  void dependencies() {
    // Register Firestore (once)
    if (!Get.isRegistered<FirebaseFirestore>()) {
      Get.put(FirebaseFirestore.instance);
    }

    // Register datasource (once)
    if (!Get.isRegistered<FirebaseTerritoryDatasource>()) {
      Get.put(FirebaseTerritoryDatasource(Get.find()));
    }

    // Register repository impl (once)
    if (!Get.isRegistered<TerritoryRepository>()) {
      Get.put<TerritoryRepository>(
        TerritoryRepositoryImpl(Get.find<FirebaseTerritoryDatasource>()),
      );
    }

    // Register controller (every time)
    Get.put(
      TerritoryController(repository: Get.find<TerritoryRepository>()),
    );
  }
}
