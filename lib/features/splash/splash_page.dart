import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:territory_capture/shared/widgets/loader.dart';
import '../../core/router/app_routes.dart';
import '../../shared/utility/extension.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _checkAuth() {
    Future.delayed(const Duration(seconds: 2), () {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.offAllNamed(AppRoutes.login);
      } else {
        Get.offAllNamed(AppRoutes.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Icon(Icons.landscape, size:100, color: context.colors.primary),
            const SizedBox(height:16),
            Text('Territory Capture', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height:8),
            Text('Capture real-world territories by walking around them.', textAlign: TextAlign.center, style: TextStyle(color: context.colors.onSecondary)),
            const Spacer(),
            const Loader(),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }
}