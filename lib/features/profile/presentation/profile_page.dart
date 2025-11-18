import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import '../../../shared/utility/extension.dart';
import '../../login/presentation/login_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<LoginController>();

    return Padding(
      padding: const EdgeInsets.only(bottom: 100, left: 16, right: 16),
      child: Column(
        mainAxisAlignment: .spaceBetween,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: context.colors.primaryContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.symmetric(
                vertical: BorderSide(color: AppColors.primary, width: 3),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() {
              final user = auth.user.value;
              return Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? "User",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: context.colors.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    user?.email ?? "Email not available",
                    style: TextStyle(
                      fontSize: 15,
                      color: context.colors.onSecondary,
                    ),
                  ),
                  Text(
                    user?.phoneNumber ?? "Mobile number not available",
                    style: TextStyle(
                      fontSize: 15,
                      color: context.colors.onSecondary,
                    ),
                  ),
                ],
              );
            }),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text("Logout", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => auth.signOut(),
            ),
          ),
        ],
      ),
    );
  }
}
