import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:territory_capture/core/router/app_routes.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import 'package:territory_capture/shared/widgets/app_button.dart';
import 'package:territory_capture/shared/widgets/loader.dart';
import '../../../shared/utility/extension.dart';
import '../../login/presentation/login_controller.dart';
import 'territory_controller.dart';

class TerritoryPage extends StatefulWidget {
  const TerritoryPage({super.key});

  @override
  State<TerritoryPage> createState() => _TerritoryPageState();
}

class _TerritoryPageState extends State<TerritoryPage> {
  final TerritoryController controller = Get.find();
  final auth = Get.find<LoginController>();

  @override
  void initState() {
    final uid = auth.user.value?.uid;
    if (uid != null) controller.loadUserTerritories(uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) return const Loader();
      if (controller.territories.isEmpty) {
        return Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .center,
          spacing: 16,
          children: [
            Center(
              child: Lottie.asset(
                "assets/lottie/no_data.json",
                height: 300,
                width: 300,
              ),
            ),
            Text(
              'No territories yet',
              style: TextStyle(
                color: context.colors.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            AppButton(onTap: () async {
              final uid = auth.user.value?.uid;
              await controller.loadUserTerritories(uid ?? '');
            }, text: "Refresh")
          ],
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          final uid = auth.user.value?.uid;
          await controller.loadUserTerritories(uid ?? '');
        },
        child: ListView.separated(
          itemCount: controller.territories.length,
          padding: .all(16),
          separatorBuilder: (_, _) => const SizedBox(height: 16),
          itemBuilder: (ctx, i) {
            final t = controller.territories[i];
            return GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.territoryDetail, arguments: t.id),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                    border: Border.symmetric(vertical: BorderSide(color: AppColors.primary, width: 3))
                ),
                child: Row(
                  mainAxisAlignment: .start,
                  crossAxisAlignment: .center,
                  spacing: 16,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          controller.buildStaticMapThumbnail(t.points),
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Icon(Icons.map, color: context.colors.primary),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: .center,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            '${(t.distanceMeters / 1000).toStringAsFixed(2)} km', style: TextStyle(color: context.colors.onPrimary, fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Text(DateFormat.yMMMd().add_jm().format(t.createdAt), style: TextStyle(color: context.colors.onSecondary, fontSize: 16, fontWeight: FontWeight.w400),),
                        ],
                      ),
                    ),
                    Text('${t.points.length} pts', style: TextStyle(color: context.colors.onSecondary, fontSize: 16, fontWeight: FontWeight.w400),),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
