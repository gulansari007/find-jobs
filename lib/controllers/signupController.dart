import 'package:findjobs/screens/basicdetail_screen.dart';
import 'package:findjobs/screens/bottombar_screen.dart';
import 'package:findjobs/screens/home_screen.dart';
import 'package:findjobs/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupController extends GetxController {
  final TextEditingController phonecontroller = TextEditingController();

  String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your mobile number';
    }
    if (value.length < 10 || value.length > 13) {
      return 'Enter a valid mobile number';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Mobile number can only contain digits';
    }
    return null;
  }

  @override
  void dispose() {
    phonecontroller.dispose();
    super.dispose();
  }

  var isPhoneAuthenticated = false.obs;
  var verificationId = ''.obs;
  var errorMessage = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void sendOTP(String phoneNumber) async {
    // Ensure the phone number includes the +91 code
    if (!phoneNumber.startsWith('+91')) {
      phoneNumber = '+91$phoneNumber';
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        isPhoneAuthenticated.value = true;
        errorMessage.value = '';
      },
      verificationFailed: (FirebaseAuthException e) {
        errorMessage.value = 'Verification failed: ${e.message}';
      },
      codeSent: (String verificationId, int? resendToken) {
        this.verificationId.value = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId.value = verificationId;
      },
    );
  }

  void verifyOTP(String otp) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId.value,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      isPhoneAuthenticated.value = true;
      errorMessage.value = '';
    } catch (e) {
      errorMessage.value = 'Failed to verify OTP';
    }
    Get.off(const BasicDetailScreen());
  }

  Rx<User?> firebaseUser = Rx<User?>(null);
  RxBool isLoading = false.obs;
  RxBool isLoadings = false.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

  // Register user with email and password

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      Get.snackbar('Success', 'Account created successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Save login status
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      Get.snackbar('Success', 'Logged in successfully!');
      Get.off(const BasicDetailScreen());
    } catch (e) {
      Get.snackbar('Login failed', 'Please enter correct email or password');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Google Login
  Future<void> loginWithGoogle() async {
    try {
      isLoadings.value = true;

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        isLoadings.value = false;
        Get.snackbar("Canceled", "Google sign-in canceled",
            snackPosition: SnackPosition.BOTTOM);
        return;
      }

      // Retrieve Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? accessToken = googleAuth.accessToken;
      final String? idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        // Handle error: Token missing or invalid
        isLoadings.value = false;
        Get.snackbar("Error", "Google sign-in failed. Try again.",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
        return;
      }

      // Create a new credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: idToken,
      );

      // Sign in to Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      isLoadings.value = false;
      Get.snackbar("Success", "Login successful!",
          snackPosition: SnackPosition.BOTTOM);

      // Navigate to the home screen
      Get.to(() => const BasicDetailScreen());
    } catch (e, stackTrace) {
      isLoadings.value = false;
      print('Error during Google sign-in: $e');
      print(stackTrace);
      Get.snackbar("Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red);
    }
  }

  // // Logout user
  // Future<void> logout() async {
  //   try {
  //     await _auth.signOut();
  //     Get.snackbar('Success', 'Logged out successfully!');
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    Get.offAll(const OtpScreen());
  }
}
