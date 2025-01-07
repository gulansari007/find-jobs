import 'package:findjobs/controllers/basicController.dart';
import 'package:findjobs/screens/location_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicDetailScreen extends StatefulWidget {
  const BasicDetailScreen({super.key});

  @override
  State<BasicDetailScreen> createState() => _BasicDetailScreenState();
}

class _BasicDetailScreenState extends State<BasicDetailScreen> {
  final basicDetailsController = Get.put(BasicDetailsController());
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true, // Prevent resizing on keyboard open
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Personal Information',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Please fill in your details to create a profile',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Form Fields
                            _buildTextField(
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              onChanged: (value) {
                                basicDetailsController.name.value = value;
                                basicDetailsController.checkFormValidity();
                              },
                              validator: basicDetailsController.validateName,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _buildTextField(
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                basicDetailsController.email.value = value;
                                basicDetailsController.checkFormValidity();
                              },
                              validator: basicDetailsController.validateEmail,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _buildTextField(
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              keyboardType: TextInputType.phone,
                              onChanged: (value) {
                                basicDetailsController.phone.value = value;
                                basicDetailsController.checkFormValidity();
                              },
                              validator: basicDetailsController.validatePhone,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Obx(
                              () => _buildDateField(
                                label: 'Date of Birth',
                                icon: Icons.calendar_today_outlined,
                                value: basicDetailsController.dateOfBirth.value,
                                onTap: () {
                                  basicDetailsController.selectDate(context);
                                  basicDetailsController.checkFormValidity();
                                },
                                validator: () =>
                                    basicDetailsController.validateDateOfBirth(
                                  basicDetailsController.dateOfBirth.value,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _buildDropdownField(
                              label: 'Gender',
                              icon: Icons.people_outline,
                              value: basicDetailsController.gender.value,
                              items: basicDetailsController.genderOptions,
                              onChanged: (value) {
                                basicDetailsController.gender.value =
                                    value ?? '';
                                basicDetailsController.checkFormValidity();
                              },
                              validator: () =>
                                  basicDetailsController.validateGender(
                                basicDetailsController.gender.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      left: 16,
                      right: 16,
                    ),
                    child: ElevatedButton(
                      onPressed: basicDetailsController.isFormValid.value
                          ? basicDetailsController.submitForm
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            basicDetailsController.isFormValid.value
                                ? Get.theme.primaryColor
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  // Reusable input decoration
  InputDecoration _inputDecoration(String labelText, IconData icon) {
    return InputDecoration(
      labelText: labelText,
      prefixIcon: Icon(icon, color: Colors.grey),
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
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

  // Custom TextField Builder
  Widget _buildTextField({
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: _inputDecoration(label, icon),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  // Custom Date Field Builder
  Widget _buildDateField({
    required String label,
    required IconData icon,
    DateTime? value,
    required VoidCallback onTap,
    required String? Function() validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: _inputDecoration(label, icon),
        readOnly: true,
        controller: TextEditingController(
          text: value != null ? DateFormat('dd/MM/yyyy').format(value) : '',
        ),
        onTap: onTap,
        validator: (_) => validator(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }

  // Custom Dropdown Field Builder
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function() validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        decoration: _inputDecoration(label, icon),
        value: value,
        hint: Text('Select $label'),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (_) => validator(),
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}
