import 'package:get/get.dart';
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
        Get.snackbar('Not found', 'Territory not found');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}