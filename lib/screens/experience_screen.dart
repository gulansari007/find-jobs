import 'package:findjobs/controllers/experienceController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({super.key});

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  final experienceController = Get.put(ExperienceController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Work Experience',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildQuestionSection(experienceController),
              const SizedBox(height: 20),
              Obx(() => experienceController.isExperienceSelected.value
                  ? _buildExperienceDetailsSection(experienceController)
                  : const SizedBox.shrink()),
              const SizedBox(
                height: 8,
              ),
              Obx(() => experienceController.isExperienceSelected.value
                  ? _buildNextButton(experienceController)
                  : const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionSection(ExperienceController controller) {
    return Column(
      children: [
        const Text(
          'Do you have any work experience?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _experienceButton(
              controller,
              text: 'No',
              value: false,
            ),
            const SizedBox(width: 20),
            _experienceButton(
              controller,
              text: 'Yes',
              value: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _experienceButton(
    ExperienceController controller, {
    required String text,
    required bool value,
  }) {
    return Obx(() => ElevatedButton(
          onPressed: () => controller.setExperience(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.hasExperience.value == value
                ? Get.theme.primaryColor
                : Colors.grey.shade300,
            foregroundColor: controller.hasExperience.value == value
                ? Colors.white
                : Colors.black87,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }

  Widget _buildExperienceDetailsSection(ExperienceController controller) {
    return Obx(() => controller.hasExperience.value
        ? Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Work Experience Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.companyController,
                    label: 'Company Name',
                    hint: 'Enter company name',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.positionController,
                    label: 'Position',
                    hint: 'Your job title',
                    icon: Icons.work,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.jobRoleController,
                    label: 'Job Role',
                    hint: 'Describe your job role',
                    icon: Icons.account_circle,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.yearsOfExperienceController,
                    label: 'Years of Experience',
                    hint: 'How many years of experience?',
                    icon: Icons.access_time,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.salaryController,
                    label: 'Salary',
                    hint: 'Enter your salary (optional)',
                    icon: Icons.monetization_on,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.startDateController,
                          label: 'Start Date',
                          hint: 'MM/YYYY',
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.endDateController,
                          label: 'End Date',
                          hint: 'MM/YYYY (or Present)',
                          icon: Icons.calendar_today,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    controller: controller.responsibilitiesController,
                    label: 'Key Responsibilities',
                    hint: 'Describe your main tasks and achievements',
                    icon: Icons.description,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      onChanged: (_) => experienceController.updateButtonState(),
      maxLines: maxLines,
      style: const TextStyle(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey),
        fillColor: Colors.grey.shade100,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(
          color: Colors.grey.shade600,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildNextButton(ExperienceController controller) {
    return Obx(() => ElevatedButton(
          onPressed: controller.isButtonEnabled.value
              ? controller.saveExperienceDetails
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isButtonEnabled.value
                ? Get.theme.primaryColor
                : Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Next',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ));
  }
}
