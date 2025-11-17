import 'package:get/get.dart';
import '../domain/territory_entity.dart';
import '../domain/territory_repository.dart';

class TerritoryController extends GetxController {
  final TerritoryRepository repository;
  TerritoryController({required this.repository});

  final territories = <Territory>[].obs;
  final isLoading = false.obs;

  Future<void> loadUserTerritories(String userId) async {
    try {
      isLoading.value = true;
      final list = await repository.getUserTerritories(userId);
      territories.value = list;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}