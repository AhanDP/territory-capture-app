import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import 'package:territory_capture/shared/utility/extension.dart';
import '../../map_capture/presentation/map_capture_page.dart';
import '../../profile/presentation/profile_page.dart';
import '../../territory/presentation/territory_page.dart';
import 'main_controller.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MainController());

    final pages = [
      const MapCapturePage(),
      const TerritoryPage(),
      const ProfilePage(),
    ];

    return Obx(() => Scaffold(
      appBar: AppBar(title: Text("Welcome!")),
      backgroundColor: context.colors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            IndexedStack(
              index: controller.currentIndex.value,
              children: pages,
            ),
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BottomNavigationBar(
                  currentIndex: controller.currentIndex.value,
                  onTap: controller.changeTab,
                  backgroundColor: context.colors.primaryContainer,
                  selectedItemColor: AppColors.primary,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.shifting,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.map),
                      label: "Capture",
                      backgroundColor: context.colors.primaryContainer,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.layers_rounded),
                      label: "Territories",
                      backgroundColor: context.colors.primaryContainer,
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: "Profile",
                      backgroundColor: context.colors.primaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}