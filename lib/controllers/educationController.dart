import 'package:findjobs/modals/education_modal.dart';
import 'package:findjobs/screens/experience_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void onInit() {
    super.onInit();
    loadEducationDetails(); // Load saved details on initialization
  }

  // Validators
  String? validateInstitution(String? value) {
    if (value == null || value.isEmpty) {
      return 'Institution name is required';
    }
    return null;
  }

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

  void saveEducationDetails() async {
    if (selectedEducationLevel.value == null) {
      Get.snackbar('Error', 'Please select your highest education level');
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'educationLevel', selectedEducationLevel.value?.name ?? '');
    await prefs.setString('institution', institutionController.text);
    await prefs.setString('fieldOfStudy', fieldOfStudyController.text);
    await prefs.setString('degreeName', degreeNameController.text);
    await prefs.setString('specialization', specializationController.text);
    await prefs.setBool('isCurrentlyStudying', isCurrentlyStudying.value);
    await prefs.setString('graduationYear', graduationYearController.text);
    await prefs.setString('schoolMedium', selectedSchoolMedium.value);

    // Get.snackbar('Success', 'Education details saved successfully');
    Get.to(const ExperienceScreen());
  }

  void loadEducationDetails() async {
    final prefs = await SharedPreferences.getInstance();

    final educationLevelName = prefs.getString('educationLevel');
    if (educationLevelName != null) {
      selectedEducationLevel.value = EducationLevel.values
          .firstWhere((e) => e.name == educationLevelName, orElse: () => null);
    }

    institutionController.text = prefs.getString('institution') ?? '';
    fieldOfStudyController.text = prefs.getString('fieldOfStudy') ?? '';
    degreeNameController.text = prefs.getString('degreeName') ?? '';
    specializationController.text = prefs.getString('specialization') ?? '';
    isCurrentlyStudying.value = prefs.getBool('isCurrentlyStudying') ?? false;
    graduationYearController.text = prefs.getString('graduationYear') ?? '';
    selectedSchoolMedium.value = prefs.getString('schoolMedium') ?? '';
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
