import 'package:findjobs/controllers/skillsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final skillsController = Get.put(SkillsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Skills',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(() => skillsController.selectedSkills.isNotEmpty
              ? TextButton(
                  onPressed: skillsController.clearSelectedSkills,
                  child: Text('Clear All',
                      style: TextStyle(color: Get.theme.primaryColor)))
              : const SizedBox.shrink())
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose skills that showcase your expertise',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            // Custom skill input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: skillsController.customSkillController,
                    decoration: InputDecoration(
                      hintText: 'Add other skills',
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: IconButton(
                          onPressed: () {
                            skillsController.addCustomSkill();
                          },
                          icon: Icon(
                            Icons.add_circle,
                            color: Get.theme.primaryColor,
                          )),
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide:
                            const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => skillsController.addCustomSkill(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Custom skills display
            Obx(() => skillsController.customSkills.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Custom Skills',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: skillsController.customSkills.map((skill) {
                          final isSelected =
                              skillsController.selectedSkills.contains(skill);
                          return ChoiceChip(
                            label: Text(
                              skill,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (_) =>
                                skillsController.toggleSkill(skill),
                            selectedColor: Get.theme.primaryColor,
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],
                  )
                : const SizedBox.shrink()),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: _buildSkillCategories(),
              ),
            ),
            // Bottom section for selected skills
            _buildSelectedSkillsSection()
          ],
        ),
      ),
    );
  }

  // Build skill categories with chips
  List<Widget> _buildSkillCategories() {
    return skillsController.suggestedSkills.keys.map((category) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              category,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Obx(() => Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children:
                    skillsController.suggestedSkills[category]!.map((skill) {
                  final isSelected =
                      skillsController.selectedSkills.contains(skill);
                  return ChoiceChip(
                    label: Text(
                      skill,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => skillsController.toggleSkill(skill),
                    selectedColor: Get.theme.primaryColor,
                    backgroundColor: Colors.grey[200],
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  );
                }).toList(),
              )),
          const SizedBox(height: 16),
        ],
      );
    }).toList();
  }

  // Build selected skills section with continue button
  Widget _buildSelectedSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: skillsController.selectedSkills.isNotEmpty ? null : 0,
              child: skillsController.selectedSkills.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Selected Skills (${skillsController.selectedSkills.length})',
                        //   style: const TextStyle(
                        //       fontSize: 16, fontWeight: FontWeight.w600),
                        // ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children:
                              skillsController.selectedSkills.map((skill) {
                            return Chip(
                              label: Text(skill),
                              deleteIcon: const Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                              onDeleted: () =>
                                  skillsController.toggleSkill(skill),
                              backgroundColor: Get.theme.primaryColor,
                              deleteIconColor: Get.theme.primaryColor,
                              labelStyle: const TextStyle(color: Colors.white),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],
                    )
                  : const SizedBox.shrink(),
            )),
        Obx(() => ElevatedButton(
              onPressed: skillsController.selectedSkills.isNotEmpty
                  ? skillsController.continueWithSkills
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )),
      ],
    );
  }
}
