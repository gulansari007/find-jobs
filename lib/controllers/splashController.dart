import 'package:findjobs/screens/chat.dart';
import 'package:findjobs/screens/chat_login.dart';
import 'package:findjobs/screens/messeges_screen.dart';
import 'package:findjobs/screens/otp_screen.dart';
import 'package:findjobs/screens/upload_screen.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      Get.off(() => const OtpScreen());
    });
    super.onInit();
  }
}
