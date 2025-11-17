import 'package:get/get.dart';
import '../../features/login/presentation/login_binding.dart';
import '../../features/login/presentation/login_page.dart';
import '../../features/map_capture/presentation/map_capture_binding.dart';
import '../../features/map_capture/presentation/map_capture_page.dart';
import '../../features/territory/presentation/territory_binding.dart';
import '../../features/territory/presentation/territory_page.dart';
import '../../features/territory_detail/presentation/territory_detail_binding.dart';
import '../../features/territory_detail/presentation/territory_detail_page.dart';

class AppRoutes {
  static const login = '/login';
  static const mapCapture = '/map_capture';
  static const territory = '/territory';
  static const territoryDetail = '/territory_detail';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.mapCapture,
      page: () => const MapCapturePage(),
      binding: MapCaptureBinding(),
    ),
    GetPage(
      name: AppRoutes.territory,
      page: () => const TerritoryPage(),
      binding: TerritoryBinding(),
    ),
    GetPage(
      name: AppRoutes.territoryDetail,
      page: () => const TerritoryDetailPage(),
      binding: TerritoryDetailBinding(),
    ),
  ];
}