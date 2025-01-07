import 'package:findjobs/screens/skills_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExperienceController extends GetxController {
  final RxBool hasExperience = RxBool(false);
  final RxBool isExperienceSelected = RxBool(false);

  // Experience form controllers
  final companyController = TextEditingController();
  final positionController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  final responsibilitiesController = TextEditingController();

  final jobRoleController = TextEditingController();
  final yearsOfExperienceController = TextEditingController();
  final salaryController = TextEditingController();

  final RxBool isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadExperienceDetails(); // Load saved details when the controller initializes
  }

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

  void saveExperienceDetails() async {
    if (validateExperienceDetails()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasExperience', hasExperience.value);
      await prefs.setString('company', companyController.text);
      await prefs.setString('position', positionController.text);
      await prefs.setString('startDate', startDateController.text);
      await prefs.setString('endDate', endDateController.text);
      await prefs.setString(
          'responsibilities', responsibilitiesController.text);
      await prefs.setString('jobRole', jobRoleController.text);
      await prefs.setString(
          'yearsOfExperience', yearsOfExperienceController.text);
      await prefs.setString('salary', salaryController.text);

      Get.snackbar('Success', 'Experience details saved successfully');
      Get.to(const SkillsScreen());
    }
  }

  void loadExperienceDetails() async {
    final prefs = await SharedPreferences.getInstance();
    hasExperience.value = prefs.getBool('hasExperience') ?? false;
    companyController.text = prefs.getString('company') ?? '';
    positionController.text = prefs.getString('position') ?? '';
    startDateController.text = prefs.getString('startDate') ?? '';
    endDateController.text = prefs.getString('endDate') ?? '';
    responsibilitiesController.text = prefs.getString('responsibilities') ?? '';
    jobRoleController.text = prefs.getString('jobRole') ?? '';
    yearsOfExperienceController.text =
        prefs.getString('yearsOfExperience') ?? '';
    salaryController.text = prefs.getString('salary') ?? '';
    updateButtonState();
  }

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

  @override
  void onClose() {
    // Dispose controllers
    companyController.dispose();
    positionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    responsibilitiesController.dispose();
    jobRoleController.dispose();
    yearsOfExperienceController.dispose();
    salaryController.dispose();
    super.onClose();
  }
}
