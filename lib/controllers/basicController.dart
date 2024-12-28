import 'package:findjobs/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BasicDetailsController extends GetxController {
  // Reactive variables
  final name = ''.obs;
  final email = ''.obs;
  final phone = ''.obs;
  final Rx<DateTime?> dateOfBirth = Rx<DateTime?>(null);
  final gender = Rx<String?>(null);

  // List of genders
  final genderOptions = ['Male', 'Female', 'Other', 'Prefer not to say'];

  // Validation methods (same as previous implementation)
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
      // Success animation or navigation
      Get.to(const LocationScreen());
      // Get.dialog(
      //   AlertDialog(
      //     title: const Text('Profile Created'),
      //     content: const Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(Icons.check_circle, color: Colors.green, size: 100),
      //         SizedBox(height: 16),
      //         Text('Your profile has been successfully created!'),
      //       ],
      //     ),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Get.back(); // Close dialog
      //           // TODO: Navigate to next screen or perform next action
      //         },
      //         child: const Text('Continue'),
      //       ),
      //     ],
      //   ),
      //   barrierDismissible: false,
      // );
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

  // Add validation methods

  void checkFormValidity() {
    isFormValid.value = validateName(name.value) == null &&
        validateEmail(email.value) == null &&
        validatePhone(phone.value) == null &&
        validateDateOfBirth(dateOfBirth.value) == null &&
        validateGender(gender.value) == null;
  }
}
