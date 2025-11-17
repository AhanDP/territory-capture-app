import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:territory_capture/core/router/app_routes.dart';
import 'package:territory_capture/shared/widgets/app_dialogs.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = Rxn<User>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    user.value = _auth.currentUser;
    _auth.userChanges().listen((u) => user.value = u);
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _auth.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.main);
    } catch (e) {
      if (Get.context != null) {
        AppDialogs.instance.showToast('Error, ${e.toString()}');
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  String? get userId => user.value?.uid;
}