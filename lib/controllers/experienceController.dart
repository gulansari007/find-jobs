import 'package:findjobs/screens/skills_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperienceController extends GetxController {
  final RxBool hasExperience = RxBool(false);
  final RxBool isExperienceSelected = RxBool(false);

  // Experience form controllers
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final responsibilitiesController = TextEditingController();

  var jobRoleController = TextEditingController();
  var yearsOfExperienceController = TextEditingController();
  var salaryController = TextEditingController();

  // void setExperience(bool value) {
  //   hasExperience.value = value;
  //   isExperienceSelected.value = true;
  // }

  bool validateExperienceDetails() {
    if (hasExperience.value) {
      if (companyController.text.isEmpty ||
          positionController.text.isEmpty ||
          startDateController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please fill in all required fields',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        return false;
      }
    }
    return true;
  }

  void saveExperienceDetails() {
    if (validateExperienceDetails()) {
      // TODO: Implement actual saving logic
      print('Saving Experience Details:');
      print('Has Experience: ${hasExperience.value}');
      if (hasExperience.value) {
        print('Company: ${companyController.text}');
        print('Position: ${positionController.text}');
        print('Start Date: ${startDateController.text}');
        print('End Date: ${endDateController.text}');
        print('Responsibilities: ${responsibilitiesController.text}');
      }

      // Navigate to next screen
      Get.to(const SkillsScreen());
    }
  }

  @override
  void onClose() {
    // Dispose controllers
    companyController.dispose();
    positionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    responsibilitiesController.dispose();
    super.onClose();
  }

  RxBool isButtonEnabled = false.obs;

  void clearFields() {
    companyController.clear();
    positionController.clear();
    jobRoleController.clear();
    yearsOfExperienceController.clear();
    salaryController.clear();
    startDateController.clear();
    endDateController.clear();
    responsibilitiesController.clear();
  }

  void updateButtonState() {
    if (hasExperience.value) {
      isButtonEnabled.value = companyController.text.isNotEmpty &&
          positionController.text.isNotEmpty &&
          jobRoleController.text.isNotEmpty &&
          yearsOfExperienceController.text.isNotEmpty &&
          startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty &&
          responsibilitiesController.text.isNotEmpty;
    } else {
      isButtonEnabled.value = false;
    }
  }

  void setExperience(bool value) {
    hasExperience.value = value;
    isExperienceSelected.value = true;

    if (!value) {
      // If "No" is selected, clear fields and enable the button
      clearFields();
      isButtonEnabled.value = true;
    } else {
      // If "Yes" is selected, validate fields
      updateButtonState();
    }
  }
}
