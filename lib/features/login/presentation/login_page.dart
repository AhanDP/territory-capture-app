import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:territory_capture/features/login/presentation/login_controller.dart';
import 'package:territory_capture/shared/utility/extension.dart';
import 'package:territory_capture/shared/widgets/loader.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const .symmetric(horizontal:20.0),
          child: Column(
            children: [
              const SizedBox(height:48),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.landscape, size:100, color: context.colors.primary),
                    const SizedBox(height:16),
                    Text('Territory Capture', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height:8),
                    Text('Capture real-world territories by walking around them.', textAlign: TextAlign.center, style: TextStyle(color: context.colors.onSecondary)),
                  ],
                ),
              ),
              Obx(() => controller.isLoading.value ? const Loader() :
              ElevatedButton(
                onPressed: () => controller.signInWithGoogle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/icons/google.png",
                      height: 22,
                      width: 22,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              )
              ),
              const SizedBox(height:22),
            ],
          ),
        ),
      ),
    );
  }
}