import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:lottie/lottie.dart';
import 'package:territory_capture/shared/utility/extension.dart';

class AppDialogs {
  AppDialogs._();

  static final AppDialogs instance = AppDialogs._();

  BuildContext? get _context => Get.context;

  // Toast
  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: isError ? Colors.redAccent : Colors.black87,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
  }

  Future<void> showSuccess(
    String message, {
    String title = 'Success',
    VoidCallback? onOkPressed,
  }) async {
    await _showDialog(
      lottie: "assets/lottie/success.json",
      title: title,
      message: message,
      onOkPressed: onOkPressed,
    );
  }

  Future<void> showError(
    String message, {
    String title = 'Error',
    VoidCallback? onOkPressed,
  }) async {
    await _showDialog(
      lottie: "assets/lottie/error.json",
      title: title,
      message: message,
      onOkPressed: onOkPressed,
    );
  }

  Future<void> showLoading({String message = 'Please wait...'}) async {
    final ctx = _context;
    if (ctx == null) return;

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 20),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }

  void hideDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  Future<void> _showDialog({
    required String lottie,
    required String title,
    required String message,
    VoidCallback? onOkPressed,
  }) async {
    final ctx = _context;
    if (ctx == null) return;

    await showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: const EdgeInsets.only(top: 20),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

        title: Column(
          children: [
            Lottie.asset(lottie, width: 120, height: 120),
            const SizedBox(height: 10),
          ],
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: context.colors.onPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: context.colors.onSecondary,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 120,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                onOkPressed?.call();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
