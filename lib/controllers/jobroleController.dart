import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  // Method to add a job role
  void addJobRole(String role) {
    if (role.isNotEmpty && !selectedJobRoles.contains(role)) {
      selectedJobRoles.add(role);
      jobRoleController.clear();
    }
  }

  // Method to remove a job role
  void removeJobRole(String role) {
    selectedJobRoles.remove(role);
  }

  // Validate if continue is possible
  bool get canContinue => selectedJobRoles.isNotEmpty;

  @override
  void onClose() {
    jobRoleController.dispose();
    super.onClose();
  }
}
