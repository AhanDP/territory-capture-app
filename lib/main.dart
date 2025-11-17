import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/bindings/initial_binding.dart';
import 'core/router/app_routes.dart';
import 'firebase_options.dart';
import 'shared/theme/app_colors.dart';
import 'shared/theme/app_typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  InitialBindings().dependencies();

  runApp(const TerritoryCaptureApp());
}

class TerritoryCaptureApp extends StatelessWidget {
  const TerritoryCaptureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: AppRoutes.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Territory Capture',
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.textPrimaryLight,
          secondary: AppColors.secondary,
          onSecondary: AppColors.textSecondaryLight,
          surface: AppColors.backgroundLight,
          primaryContainer: AppColors.cardLight,
          error: AppColors.error,
          onError: Colors.white,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.textPrimaryDark,
          secondary: AppColors.secondary,
          onSecondary: AppColors.textSecondaryDark,
          surface: AppColors.backgroundDark,
          primaryContainer: AppColors.cardDark,
          error: AppColors.error,
          onError: Colors.white,
        ),
        textTheme: TextTheme(
          headlineLarge: AppTypography.headlineLarge,
          headlineMedium: AppTypography.headlineMedium,
          headlineSmall: AppTypography.headlineSmall,
          bodyLarge: AppTypography.bodyLarge,
          bodyMedium: AppTypography.bodyMedium,
          bodySmall: AppTypography.bodySmall,
          labelLarge: AppTypography.labelLarge,
          labelMedium: AppTypography.labelMedium,
          labelSmall: AppTypography.labelSmall,
        ).apply(
          bodyColor: AppColors.textPrimaryDark,
          displayColor: AppColors.textPrimaryDark,
        ),
      ),
    );
  }
}