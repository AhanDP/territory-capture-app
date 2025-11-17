// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:go_router/go_router.dart';
// import '../../core/router/app_router.dart';
//
// class AppDialogs {
//   AppDialogs._();
//   static final AppDialogs instance = AppDialogs._();
//   BuildContext? get _context => AppRouter.instance.router.configuration.navigatorKey.currentContext;
//
//   // ✅ Toast
//   void showToast(String message, {bool isError = false}) {
//     Fluttertoast.showToast(
//       msg: message,
//       backgroundColor: isError ? Colors.redAccent : Colors.black87,
//       textColor: Colors.white,
//       gravity: ToastGravity.TOP,
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   // ✅ Success Dialog
//   Future<void> showSuccess(String message, {String title = 'Success', VoidCallback? onOkPressed}) async {
//     await _showDialog(
//       icon: Icons.check_circle,
//       iconColor: Colors.green,
//       title: title,
//       message: message,
//       onOkPressed: onOkPressed,
//     );
//   }
//
//   // ❌ Error Dialog
//   Future<void> showError(
//       String message, {
//         String title = 'Error',
//         VoidCallback? onOkPressed,
//       }) async {
//     await _showDialog(
//       icon: Icons.error_outline,
//       iconColor: Colors.redAccent,
//       title: title,
//       message: message,
//       onOkPressed: onOkPressed,
//     );
//   }
//
//   // ℹ️ Info Dialog
//   Future<void> showInfo(
//       String message, {
//         String title = 'Information',
//         VoidCallback? onOkPressed,
//       }) async {
//     await _showDialog(
//       icon: Icons.info_outline,
//       iconColor: Colors.blueAccent,
//       title: title,
//       message: message,
//       onOkPressed: onOkPressed,
//     );
//   }
//
//   Future<bool?> showConfirm({
//     required String title,
//     required String message,
//     String confirmText = 'Yes',
//     String cancelText = 'No',
//   }) async {
//     final ctx = _context;
//     if (ctx == null) return false;
//
//     return showDialog<bool>(
//       context: ctx,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () => context.pop(false),
//             child: Text(cancelText),
//           ),
//           ElevatedButton(
//             onPressed: () => context.pop(true),
//             child: Text(confirmText),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // 🚀 Loading Dialog
//   Future<void> showLoading({String message = 'Please wait...'}) async {
//     final ctx = _context;
//     if (ctx == null) return;
//     showDialog(
//       context: ctx,
//       barrierDismissible: false,
//       builder: (context) => PopScope(
//         canPop: false,
//         child: AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//           content: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const CircularProgressIndicator(),
//               const SizedBox(width: 20),
//               Text(message),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   void hideDialog() {
//     final ctx = _context;
//     if (ctx == null || !ctx.canPop()) return;
//     ctx.pop();
//   }
//
//   Future<void> _showDialog({
//     required IconData icon,
//     required Color iconColor,
//     required String title,
//     required String message,
//     VoidCallback? onOkPressed,
//   }) async {
//     final ctx = _context;
//     if (ctx == null) return;
//
//     await showDialog(
//       context: ctx,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Icon(icon, color: iconColor, size: 28),
//             const SizedBox(width: 10),
//             Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           ],
//         ),
//         content: Text(message),
//         actions: [
//           TextButton(
//             onPressed: () {
//               context.pop();
//               if (onOkPressed != null) onOkPressed();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }
// }