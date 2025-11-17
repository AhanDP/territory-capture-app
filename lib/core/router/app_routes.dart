import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../features/login/presentation/login_binding.dart';
import '../../features/login/presentation/login_page.dart';
import '../../features/main/presentation/main_page.dart';
import '../../features/map_capture/presentation/map_capture_binding.dart';
import '../../features/splash/splash_page.dart';
import '../../features/territory/presentation/territory_binding.dart';
import '../../features/territory_detail/presentation/territory_detail_binding.dart';
import '../../features/territory_detail/presentation/territory_detail_page.dart';

class AppRoutes {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static const splash = '/splash';
  static const login = '/login';
  static const main = '/main';
  static const territoryDetail = '/territory_detail';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.main,
      page: () => const MainPage(),
      binding: BindingsBuilder(() {
        MapCaptureBinding().dependencies();
        TerritoryBinding().dependencies();
      }),
    ),
    GetPage(
      name: AppRoutes.territoryDetail,
      page: () => const TerritoryDetailPage(),
      binding: TerritoryDetailBinding(),
    ),
  ];
}