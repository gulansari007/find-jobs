import 'package:findjobs/controllers/signupController.dart';
import 'package:findjobs/screens/basicdetail_screen.dart';
import 'package:findjobs/screens/bottombar_screen.dart';
import 'package:findjobs/screens/education_screen.dart';
import 'package:findjobs/screens/experience_screen.dart';
import 'package:findjobs/screens/job_role_screen.dart';
import 'package:findjobs/screens/location_screen.dart';
import 'package:findjobs/screens/otp_screen.dart';
import 'package:findjobs/screens/signup_screen.dart';
import 'package:findjobs/screens/skills_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final signupController = Get.put(SignupController());
  bool isLoggedIn = false;
  bool isBasicDetailsCompleted = false;
  bool isLocationCompleted = false;
  bool isEducationCompleted = false;
  bool isWorkExperienceCompleted = false;
  bool isSkillsCompleted = false;
  bool isJobRolesCompleted = false;

  @override
  void onInit() {
    super.onInit();
    _checkProgressStatus();
    debugSharedPreferences(); // Add this line to call the debug method
  }

  Future<void> _checkProgressStatus() async {
    try {
      // Retrieve data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      isBasicDetailsCompleted =
          prefs.getBool('isBasicDetailsCompleted') ?? false;
      isLocationCompleted = prefs.getBool('isLocationCompleted') ?? false;
      isEducationCompleted = prefs.getBool('isEducationCompleted') ?? false;
      isWorkExperienceCompleted =
          prefs.getBool('isWorkExperienceCompleted') ?? false;
      isSkillsCompleted = prefs.getBool('isSkillsCompleted') ?? false;
      isJobRolesCompleted = prefs.getBool('isJobRolesCompleted') ?? false;

      // Delay for splash screen
      await Future.delayed(const Duration(seconds: 3));

      // Navigate based on progress
      if (!isLoggedIn) {
        Get.off(() => const BottomBarScreen());
      } else {
        _navigateToNextIncompleteScreen();
      }
    } catch (e) {
      print('Error checking progress status: $e');
    }
  }

  Future<void> debugSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print(
        'All SharedPreferences Data: ${prefs.getKeys().map((key) => "$key: ${prefs.get(key)}").toList()}');
  }

  void _navigateToNextIncompleteScreen() {
    if (!isBasicDetailsCompleted) {
      Get.off(() => const BasicDetailScreen());
    } else if (!isLocationCompleted) {
      Get.off(() => const LocationScreen());
    } else if (!isEducationCompleted) {
      Get.off(() => const EducationScreen());
    } else if (!isWorkExperienceCompleted) {
      Get.off(() => const ExperienceScreen());
    } else if (!isSkillsCompleted) {
      Get.off(() => const SkillsScreen());
    } else if (!isJobRolesCompleted) {
      Get.off(() => const JobRoleScreen());
    } else {
      // Navigate to the main screen
      Get.off(() => const BottomBarScreen());
    }
  }
}
