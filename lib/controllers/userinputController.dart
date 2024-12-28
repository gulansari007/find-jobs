import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class UserInputController extends GetxController {
  // Observable variables
  final jobTitleController = TextEditingController();
  final companyNameController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  final RxString selectedJobType = 'Full-time'.obs;
  final jobTypes = [
    'Full-time',
    'Part-time',
    'Contract',
    'Freelance',
    'Internship',
    'Full-time,Part-time'
    

  ];

  final Rx<RangeValues> salaryRange = const RangeValues(30000, 100000).obs;

  // Location related observables
  final RxBool isLoadingLocation = false.obs;
  final RxString currentLocationText = ''.obs;

  // Get current location
  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // If permissions are granted, get location
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        // Get readable address from coordinates
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String locationText =
              '${place.locality}, ${place.administrativeArea}, ${place.country}';

          // Update location controller and observable
          locationController.text = locationText;
          currentLocationText.value = locationText;
        }
      } else {
        // Handle permission denied
        Get.snackbar(
          'Location Access Denied',
          'Please enable location permissions in app settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Unable to retrieve location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Form validation
  bool validateForm() {
    if (jobTitleController.text.isEmpty) {
      _showErrorSnackbar('Job Title is required');
      return false;
    }
    if (companyNameController.text.isEmpty) {
      _showErrorSnackbar('Company Name is required');
      return false;
    }
    if (locationController.text.isEmpty) {
      _showErrorSnackbar('Location is required');
      return false;
    }
    if (descriptionController.text.isEmpty) {
      _showErrorSnackbar('Job Description is required');
      return false;
    }
    return true;
  }

  // Submit form
  void submitForm() {
    if (validateForm()) {
      final jobData = {
        'jobTitle': jobTitleController.text,
        'companyName': companyNameController.text,
        'location': locationController.text,
        'jobType': selectedJobType.value,
        'salaryRangeMin': salaryRange.value.start.round(),
        'salaryRangeMax': salaryRange.value.end.round(),
        'description': descriptionController.text,
      };

      // TODO: Implement actual submission logic
      print('Job Data: $jobData');

      // Show success message
      Get.snackbar(
        'Success',
        'Job application submitted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade500,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );

      // Optional: Clear form or navigate
      clearForm();
    }
  }

  // Clear form fields
  void clearForm() {
    jobTitleController.clear();
    companyNameController.clear();
    locationController.clear();
    descriptionController.clear();
    selectedJobType.value = 'Full-time';
    salaryRange.value = const RangeValues(30000, 100000);
    currentLocationText.value = '';
  }

  // Show error snackbar
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade500,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
    );
  }

  @override
  void onClose() {
    // Dispose controllers
    jobTitleController.dispose();
    companyNameController.dispose();
    locationController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}
