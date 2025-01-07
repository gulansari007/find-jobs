import 'package:findjobs/controllers/educationController.dart';
import 'package:findjobs/modals/education_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final educationDetailsController = Get.put(EducationDetailsController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Add listeners to update the button state dynamically
    educationDetailsController.institutionController
        .addListener(_updateFormValidity);
    educationDetailsController.fieldOfStudyController
        .addListener(_updateFormValidity);
    educationDetailsController.specializationController
        .addListener(_updateFormValidity);
    educationDetailsController.graduationYearController
        .addListener(_updateFormValidity);
  }

  void _updateFormValidity() {
    // Trigger a UI rebuild when the form validity changes
    setState(() {});
  }

  bool _isFormValid() {
    return educationDetailsController.selectedEducationLevel.value != null &&
        educationDetailsController.institutionController.text.isNotEmpty &&
        educationDetailsController.fieldOfStudyController.text.isNotEmpty &&
        educationDetailsController.specializationController.text.isNotEmpty &&
        (!educationDetailsController.isCurrentlyStudying.value
            ? educationDetailsController
                .graduationYearController.text.isNotEmpty
            : true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Education Details'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 12),

                      // Education Level Dropdown
                      Obx(
                        () => DropdownButtonFormField<EducationLevel>(
                          decoration:
                              _inputDecoration('Highest Education Level'),
                          value: educationDetailsController
                              .selectedEducationLevel.value,
                          items: EducationLevel.levels
                              .map(
                                (level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(
                                    level.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            educationDetailsController
                                .selectedEducationLevel.value = value;
                            _updateFormValidity();
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select your highest education level';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Institution Name
                      _buildTextField(
                        controller:
                            educationDetailsController.institutionController,
                        label: 'Institution Name',
                        hint: 'College name',
                        validator:
                            educationDetailsController.validateInstitution,
                      ),
                      const SizedBox(height: 20),

                      // Field of Study
                      _buildTextField(
                        controller:
                            educationDetailsController.fieldOfStudyController,
                        label: 'Field of Study',
                        hint: 'E.g.,   B.s.c,  B.a',
                        validator:
                            educationDetailsController.validateFieldOfStudy,
                      ),
                      const SizedBox(height: 20),

                      // Specialization
                      _buildTextField(
                        controller:
                            educationDetailsController.specializationController,
                        label: 'Specialization',
                        hint: 'E.g., Artificial Intelligence, Nanotechnology',
                        validator:
                            educationDetailsController.validateFieldOfStudy,
                      ),
                      const SizedBox(height: 20),

                      // School Medium Dropdown
                      Obx(
                        () {
                          String? selectedMedium = educationDetailsController
                              .selectedSchoolMedium.value;
                          if (!['English', 'Hindi', 'Other']
                              .contains(selectedMedium)) {
                            selectedMedium = 'English';
                          }

                          return DropdownButtonFormField<String>(
                            decoration: _inputDecoration('School Medium'),
                            value: selectedMedium,
                            items: ['English', 'Hindi', 'Other']
                                .map(
                                  (medium) => DropdownMenuItem(
                                    value: medium,
                                    child: Text(
                                      medium,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              educationDetailsController
                                  .selectedSchoolMedium.value = value!;
                              _updateFormValidity();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your school medium';
                              }
                              return null;
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Currently Studying Checkbox
                      Obx(() => CheckboxListTile(
                            title: const Text('I am currently studying'),
                            value: educationDetailsController
                                .isCurrentlyStudying.value,
                            activeColor: Colors.deepPurple,
                            onChanged: (value) {
                              educationDetailsController
                                  .updateCurrentlyStudying(value);
                              _updateFormValidity();
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          )),

                      // Graduation Year
                      Obx(() =>
                          !educationDetailsController.isCurrentlyStudying.value
                              ? _buildTextField(
                                  controller: educationDetailsController
                                      .graduationYearController,
                                  label: 'Graduation Year',
                                  keyboardType: TextInputType.number,
                                  validator: educationDetailsController
                                      .validateGraduationYear,
                                )
                              : const SizedBox.shrink()),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: _isFormValid()
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            educationDetailsController.saveEducationDetails();
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFormValid() ? Get.theme.primaryColor : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: Get.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable text field widget
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(label).copyWith(hintText: hint),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  // Enhanced input decoration
  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      filled: true,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
    );
  }
}
