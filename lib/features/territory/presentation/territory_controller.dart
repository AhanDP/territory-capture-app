import 'package:get/get.dart';
import '../../../shared/widgets/app_dialogs.dart';
import '../../login/presentation/login_controller.dart';
import '../domain/territory_entity.dart';
import '../domain/territory_repository.dart';

class TerritoryController extends GetxController {
  final TerritoryRepository repository;
  TerritoryController({required this.repository});

  final territories = <Territory>[].obs;
  final isLoading = false.obs;

  final auth = Get.find<LoginController>();

  @override
  void onReady() {
    super.onReady();
    final uid = auth.user.value?.uid;
    if (uid != null) loadUserTerritories(uid);
  }

  Future<void> loadUserTerritories(String userId) async {
    try {
      isLoading.value = true;
      final list = await repository.getUserTerritories(userId);
      territories.assignAll(list);
    } catch (e) {
      AppDialogs.instance.showToast("Error: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  String buildStaticMapThumbnail(List<LatLngPoint> points) {
    const apiKey = "AIzaSyBFJBoT5JY1L5PO3pxNfLyo2SkErw8jwek";

    final path = points
        .map((p) => "${p.lat},${p.lng}")
        .join("|");

    final center = "${points[0].lat},${points[0].lng}";

    return "https://maps.googleapis.com/maps/api/staticmap"
        "?size=300x200"
        "&scale=2"
        "&maptype=roadmap"
        "&path=color:0x2196F3FF|weight:4|$path"
        "&markers=size:tiny|color:green|${points.first.lat},${points.first.lng}"
        "&markers=size:tiny|color:red|${points.last.lat},${points.last.lng}"
        "&center=$center"
        "&zoom=17"
        "&key=$apiKey";
  }

}