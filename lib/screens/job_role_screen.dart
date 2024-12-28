import 'package:findjobs/controllers/jobroleController.dart';
import 'package:findjobs/screens/bottombar_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class JobRoleScreen extends StatefulWidget {
  const JobRoleScreen({super.key});

  @override
  State<JobRoleScreen> createState() => _JobRoleScreenState();
}

class _JobRoleScreenState extends State<JobRoleScreen> {
  final jobRoleController = Get.put(JobRoleController());
  bool isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();

    // Listen to keyboard visibility changes
    SystemChannels.textInput.invokeMethod('TextInput.show').then((_) {
      setState(() {
        isKeyboardVisible = true;
      });
    });

    SystemChannels.textInput.invokeMethod('TextInput.hide').then((_) {
      setState(() {
        isKeyboardVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Job Role'),
      ),
      body: Stack(
        children: [
          // Content of the screen
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),

                  // Subtitle
                  Text(
                    'Choose the job roles that\ninterest you',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Job Role Input
                  Container(
                    child: TextField(
                      controller: jobRoleController.jobRoleController,
                      decoration: InputDecoration(
                        hintText: 'Enter a job role',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.add_circle,
                            color: Get.theme.primaryColor,
                          ),
                          onPressed: () => jobRoleController.addJobRole(
                            jobRoleController.jobRoleController.text.trim(),
                          ),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      onSubmitted: (value) =>
                          jobRoleController.addJobRole(value.trim()),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Suggested Job Roles
                  Text(
                    'Suggested Roles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: jobRoleController.suggestedJobRoles.map((role) {
                      return Obx(() => ChoiceChip(
                            label: Text(
                              role,
                              style: TextStyle(
                                color: jobRoleController.selectedJobRoles
                                        .contains(role)
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                            selected: jobRoleController.selectedJobRoles
                                .contains(role),
                            selectedColor: Get.theme.primaryColor,
                            backgroundColor: Colors.grey[200],
                            onSelected: (bool selected) {
                              jobRoleController.addJobRole(role);
                            },
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                          ));
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // Selected Job Roles
                  Text(
                    'Your Selected Roles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[900],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children:
                            jobRoleController.selectedJobRoles.map((role) {
                          return Chip(
                            label: Text(
                              role,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            deleteIcon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                            onDeleted: () =>
                                jobRoleController.removeJobRole(role),
                            backgroundColor:
                                Get.theme.primaryColor.withOpacity(0.8),
                            deleteIconColor: Colors.white,
                          );
                        }).toList(),
                      )),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Continue Button at the bottom of the screen
          Align(
            alignment: Alignment.bottomCenter,
            child: Obx(() => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jobRoleController.canContinue
                          ? Get.theme.primaryColor
                          : Colors
                              .grey[300], // Solid color when button is enabled
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: jobRoleController.canContinue
                        ? () {
                            // Navigate to next screen or save selected roles
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Profile Created'),
                                content: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green, size: 100),
                                    SizedBox(height: 16),
                                    Text(
                                        'Your profile has been created successfully!'),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.offAll(const BottomBarScreen());
                                    },
                                    child: const Text('Continue'),
                                  ),
                                ],
                              ),
                              barrierDismissible: false,
                            );
                          }
                        : null,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: jobRoleController.canContinue
                            ? Colors.white
                            : Colors.grey[500],
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
