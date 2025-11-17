import 'package:flutter/material.dart';
import 'package:territory_capture/shared/theme/app_colors.dart';
import '../utility/extension.dart';

class AppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final Color color;

  const AppButton({
    required this.onTap,
    required this.text,
    this.color = AppColors.primary,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(text, style: TextStyle(color: context.colors.onPrimary, fontSize: 16, fontWeight: FontWeight.w600),),
    );
  }
}
