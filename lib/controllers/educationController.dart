import 'package:findjobs/modals/education_modal.dart';
import 'package:findjobs/screens/experience_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationDetailsController extends GetxController {
  var selectedEducationLevel = Rx<EducationLevel?>(null);
  var institutionController = TextEditingController();
  var fieldOfStudyController = TextEditingController();
  var degreeNameController = TextEditingController();
  var specializationController = TextEditingController();
  var isCurrentlyStudying = false.obs;
  var graduationYearController = TextEditingController();
  var selectedSchoolMedium = RxString('');
  var isFormValid = false.obs;

  // Validators
  String? validateInstitution(String? value) {
    if (value == null || value.isEmpty) {
      return 'Institution name is required';
    }
    return null;
  }

  // Validation for school medium
  String? validateSchoolMedium(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select your school medium';
    }
    return null;
  }

  String? validateFieldOfStudy(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field of Study is required';
    }
    return null;
  }

  String? validateGraduationYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Graduation year is required';
    }
    if (int.tryParse(value) == null || value.length != 4) {
      return 'Enter a valid year';
    }
    return null;
  }

  void saveEducationDetails() {
    if (selectedEducationLevel.value == null) {
      Get.snackbar('Error', 'Please select your highest education level');
      return;
    }

    // Implement save logic
    Get.to(const ExperienceScreen());
  }

  void updateCurrentlyStudying(bool? value) {
    isCurrentlyStudying.value = value ?? false;
  }

  void updateFormValidity() {
    isFormValid.value = selectedEducationLevel.value != null &&
        validateInstitution(institutionController.text) == null &&
        validateFieldOfStudy(fieldOfStudyController.text) == null &&
        (!isCurrentlyStudying.value
            ? validateGraduationYear(graduationYearController.text) == null
            : true);
  }
}
