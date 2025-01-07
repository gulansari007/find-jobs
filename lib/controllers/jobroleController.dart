import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobRoleController extends GetxController {
  // List of suggested job roles
  final suggestedJobRoles = [
    'Software Engineer',
    'UI/UX Designer',
    'Product Manager',
    'Data Scientist',
    'Marketing Specialist',
    'Sales Representative',
    'Project Manager',
    'Web Developer',
    'Mobile App Developer',
    'Business Analyst'
  ];

  // Observable list of selected job roles
  final selectedJobRoles = <String>[].obs;

  // Text controller for custom job role input
  final jobRoleController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadJobRoles(); // Load saved job roles when the controller initializes
  }

  @override
  void onClose() {
    jobRoleController.dispose();
    super.onClose();
  }

  // Method to add a job role
  void addJobRole(String role) {
    if (role.isNotEmpty && !selectedJobRoles.contains(role)) {
      selectedJobRoles.add(role);
      jobRoleController.clear();
      saveJobRoles(); // Save job roles after adding
    }
  }

  // Method to remove a job role
  void removeJobRole(String role) {
    selectedJobRoles.remove(role);
    saveJobRoles(); // Save job roles after removing
  }

  // Validate if continue is possible
  bool get canContinue => selectedJobRoles.isNotEmpty;

  // Method to save selected job roles to SharedPreferences
  void saveJobRoles() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedJobRoles', selectedJobRoles.toList());
    Get.snackbar('save', 'role');
  }

  // Method to load selected job roles from SharedPreferences
  void loadJobRoles() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedJobRoles = prefs.getStringList('selectedJobRoles');
    if (savedJobRoles != null) {
      selectedJobRoles.addAll(savedJobRoles);
    }
  }
}
