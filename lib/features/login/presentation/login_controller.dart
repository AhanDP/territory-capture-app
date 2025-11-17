import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:territory_capture/core/router/app_routes.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final isLoading = false.obs;
  final Rxn<User> user = Rxn<User>();

  late final GoogleSignIn _googleSignIn;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn = GoogleSignIn.instance;
    _initializeGoogleSignIn();

    user.value = _auth.currentUser;
    _auth.userChanges().listen((u) => user.value = u);
  }

  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize(
        clientId: null,
        serverClientId: null,
      );

      _googleSignIn.authenticationEvents.listen(
        _handleGoogleEvent,
        onError: (e) => Get.rawSnackbar(message: "Google Auth Error: $e"),
      );

      _googleSignIn.attemptLightweightAuthentication();
    } catch (e) {
      Get.rawSnackbar(message: "Google Sign-In init failed: $e");
    }
  }

  Future<void> _handleGoogleEvent(GoogleSignInAuthenticationEvent event) async {
    GoogleSignInAccount? googleUser = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    if (googleUser == null) return;

    final auth = googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: auth.idToken
    );

    try {
      await _auth.signInWithCredential(credential);
      Get.offAllNamed(AppRoutes.mapCapture);
    } catch (e) {
      Get.rawSnackbar(message: "Firebase sign-in failed: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      if (_googleSignIn.supportsAuthenticate()) {
        await _googleSignIn.authenticate();
      } else {
        Get.rawSnackbar(message: "This platform does not support Google Sign-In.");
      }
    } catch (e) {
      Get.rawSnackbar(message: "Google Sign-In failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.disconnect();
    await _auth.signOut();
    Get.offAllNamed(AppRoutes.login);
  }

  String? get userId => user.value?.uid;
}