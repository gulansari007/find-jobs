import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findjobs/controllers/userinputController.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({Key? key}) : super(key: key);

  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final userInputController = Get.put(UserInputController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'New post',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 55, right: 16, left: 16, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Job Title Input
                  _buildInputField(
                    controller: userInputController.jobTitleController,
                    label: 'Job Title',
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 16),

                  // Company Name Input
                  _buildInputField(
                    controller: userInputController.companyNameController,
                    label: 'Company Name',
                    icon: Icons.business_outlined,
                  ),
                  const SizedBox(height: 16),

                  // Location Input with Auto Location Button
                  _buildLocationInput(userInputController),
                  const SizedBox(height: 16),

                  // Job Type Dropdown
                  _buildJobTypeDropdown(userInputController),
                  const SizedBox(height: 16),

                  // Salary Range Slider
                  _buildSalaryRangeSlider(userInputController),
                  const SizedBox(height: 16),

                  // Job Description Input
                  _buildMultilineInputField(
                    controller: userInputController.descriptionController,
                    label: 'Job Description',
                    icon: Icons.description_outlined,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Fixed submit button at the bottom
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildSubmitButton(userInputController),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Location Input with Auto Location Button
  Widget _buildLocationInput(UserInputController controller) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller.locationController,
            decoration: InputDecoration(
              labelText: 'Location',
              prefixIcon: Icon(
                Icons.location_on_outlined,
                color: Get.theme.primaryColor,
              ),
              suffixIcon: Obx(
                () => controller.isLoadingLocation.value
                    ? Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(
                            color: Get.theme.primaryColor),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(
                            Icons.my_location,
                            color: Get.theme.primaryColor,
                          ),
                          onPressed: controller.getCurrentLocation,
                          tooltip: 'Use Current Location',
                        ),
                      ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.deepPurple.shade100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.deepPurple.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    BorderSide(color: Colors.deepPurple.shade300, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Custom input field widget
  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Get.theme.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
        ),
      ),
    );
  }

  // Multiline input field widget
  Widget _buildMultilineInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      maxLines: 4,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Icon(icon, color: Get.theme.primaryColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
        ),
      ),
    );
  }

  // Job Type Dropdown
  Widget _buildJobTypeDropdown(UserInputController controller) {
    return Obx(
      () => DropdownButtonFormField<String>(
        value: controller.selectedJobType.value,
        decoration: InputDecoration(
          labelText: 'Job Type',
          prefixIcon: Icon(Icons.work_outline, color: Get.theme.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade100),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade100),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.deepPurple.shade300, width: 2),
          ),
        ),
        items: controller.jobTypes.map((String type) {
          return DropdownMenuItem<String>(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (String? newValue) {
          controller.selectedJobType.value = newValue!;
        },
      ),
    );
  }

  // Salary Range Slider
  Widget _buildSalaryRangeSlider(UserInputController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'Salary Range',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor,
            ),
          ),
        ),
        Obx(
          () => RangeSlider(
            values: controller.salaryRange.value,
            min: 0,
            max: 200000,
            divisions: 100,
            labels: RangeLabels(
              '₹${controller.salaryRange.value.start.round()}',
              '₹${controller.salaryRange.value.end.round()}',
            ),
            activeColor: Get.theme.primaryColor,
            inactiveColor: Colors.deepPurple.shade100,
            onChanged: (RangeValues values) {
              controller.salaryRange.value = values;
            },
          ),
        ),
      ],
    );
  }

  // Submit Button
  Widget _buildSubmitButton(UserInputController controller) {
    return SizedBox(
      width: Get.width,
      child: ElevatedButton(
        onPressed: controller.submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.theme.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
