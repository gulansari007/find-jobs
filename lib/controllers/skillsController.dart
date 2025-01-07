import 'package:findjobs/screens/job_role_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SkillsController extends GetxController {
  // Observable list of selected skills
  final RxSet<String> selectedSkills = <String>{}.obs;

  // Controller for custom skill text field
  final TextEditingController customSkillController = TextEditingController();

  // Observable list of custom skills
  final RxList<String> customSkills = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadSkills(); // Load saved skills when the controller initializes
  }

  @override
  void onClose() {
    // Dispose the controller when the controller is closed
    customSkillController.dispose();
    super.onClose();
  }

  // Method to add a custom skill
  void addCustomSkill() {
    final skill = customSkillController.text.trim();
    if (skill.isNotEmpty) {
      // Check if the skill is not already in suggested or custom skills
      if (!suggestedSkills.values.any((list) => list.contains(skill)) &&
          !customSkills.contains(skill)) {
        customSkills.add(skill);
        selectedSkills.add(skill);
        customSkillController.clear();
        saveSkills(); // Save the skills after adding
      } else {
        // Show a snackbar if skill already exists
        Get.snackbar(
          'Duplicate Skill',
          'This skill has already been added',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    }
  }

  // List of suggested skills categorized by field
  final Map<String, List<String>> suggestedSkills = {
    'Programming': [
      'Python',
      'JavaScript',
      'Java',
      'C++',
      'React',
      'Flutter',
      'Node.js',
      'SQL'
    ],
    'Design': [
      'UI/UX Design',
      'Adobe Photoshop',
      'Figma',
      'Sketch',
      'Adobe Illustrator'
    ],
    'Marketing': [
      'Digital Marketing',
      'SEO',
      'Social Media Marketing',
      'Content Marketing',
      'Google Analytics'
    ],
    'Business': [
      'Project Management',
      'Business Analysis',
      'Excel',
      'Strategic Planning',
      'Data Analysis'
    ],
    'Data Science': [
      'Machine Learning',
      'Data Visualization',
      'R',
      'Pandas',
      'TensorFlow',
      'Data Mining'
    ]
  };

  // Method to toggle skill selection
  void toggleSkill(String skill) {
    if (selectedSkills.contains(skill)) {
      selectedSkills.remove(skill);
    } else {
      selectedSkills.add(skill);
    }
    saveSkills(); // Save the skills after toggling
  }

  // Method to clear all selected skills
  void clearSelectedSkills() {
    selectedSkills.clear();
    saveSkills(); // Save the empty set after clearing
  }

  // Method to proceed with selected skills
  void continueWithSkills() {
    if (selectedSkills.isNotEmpty) {
      saveSkills(); // Save the selected skills before proceeding
      Get.to(const JobRoleScreen());
    }
  }

  // Method to save skills to SharedPreferences
  void saveSkills() async {
    final prefs = await SharedPreferences.getInstance();

    // Save selected skills (set) as a list
    await prefs.setStringList('selectedSkills', selectedSkills.toList());

    // Save custom skills (list) as a list
    await prefs.setStringList('customSkills', customSkills.toList());
    Get.snackbar("save", "skills");
  }

  // Method to load skills from SharedPreferences
  void loadSkills() async {
    final prefs = await SharedPreferences.getInstance();

    // Load selected skills (set)
    List<String>? savedSelectedSkills = prefs.getStringList('selectedSkills');
    if (savedSelectedSkills != null) {
      selectedSkills.addAll(savedSelectedSkills);
    }

    // Load custom skills
    List<String>? savedCustomSkills = prefs.getStringList('customSkills');
    if (savedCustomSkills != null) {
      customSkills.addAll(savedCustomSkills);
    }
  }
}
