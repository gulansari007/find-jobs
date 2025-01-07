import 'package:findjobs/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicDetailsController extends GetxController {
  // Reactive variables
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final gender = Rx<String?>(null);

  // List of genders
  final genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // Validation methods
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? validateDateOfBirth(DateTime? value) {
    if (value == null) {
      return 'Please select your date of birth';
    }
    return null;
  }

  String? validateGender(String? value) {
    if (value == null) {
      return 'Please select your gender';
    }
    return null;
  }

  // Date selection method
  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth.value ?? DateTime.now(),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onPrimary: Colors.white,
              surface: Get.theme.primaryColor,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateOfBirth.value = picked;
    }
  }

  // Form submission method
  void submitForm() {
    if (validateName(name.value) == null &&
        validateEmail(email.value) == null &&
        validatePhone(phone.value) == null &&
        validateDateOfBirth(dateOfBirth.value) == null &&
        validateGender(gender.value) == null) {
      saveDataToSharedPreferences(); // Save to SharedPreferences after validation
      Get.to(const LocationScreen());
    } else {
      Get.snackbar(
        'Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
    }
  }

  var isFormValid = false.obs;

  void checkFormValidity() {
    isFormValid.value = validateName(name.value) == null &&
        validateEmail(email.value) == null &&
        validatePhone(phone.value) == null &&
        validateDateOfBirth(dateOfBirth.value) == null &&
        validateGender(gender.value) == null;
  }

  // Save form data to SharedPreferences
  Future<void> saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name.value);
    await prefs.setString('email', email.value);
    await prefs.setString('phone', phone.value);
    await prefs.setString(
        'dateOfBirth', dateOfBirth.value?.toIso8601String() ?? '');
    await prefs.setString('gender', gender.value ?? '');

    Get.snackbar(
      'Success',
      'Your details have been saved successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade600,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
    );
  }

  // Load data from SharedPreferences
  Future<void> loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    name.value = prefs.getString('name') ?? '';
    email.value = prefs.getString('email') ?? '';
    phone.value = prefs.getString('phone') ?? '';
    final dobString = prefs.getString('dateOfBirth');
    dateOfBirth.value = dobString != null && dobString.isNotEmpty
        ? DateTime.parse(dobString)
        : null;
    gender.value = prefs.getString('gender');
  }

  @override
  void onInit() {
    super.onInit();
    loadDataFromSharedPreferences(); // Load saved data when the controller initializes
  }
}
