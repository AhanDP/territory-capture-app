import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:territory_capture/features/login/presentation/login_controller.dart';

import '../../features/territory/data/data_source/territory_data_source.dart';
import '../../features/territory/data/repositories/territory_repository_impl.dart';
import '../../features/territory/domain/territory_repository.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // Firebase core Firestore instance
    Get.put(FirebaseFirestore.instance);

    // Datasource
    Get.put(FirebaseTerritoryDatasource(Get.find<FirebaseFirestore>()));

    // Repository
    Get.put<TerritoryRepository>(
      TerritoryRepositoryImpl(Get.find<FirebaseTerritoryDatasource>()),
    );

    // Global Auth controller
    Get.put(LoginController(), permanent: true);
  }
}