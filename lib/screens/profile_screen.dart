import 'dart:io';

import 'package:findjobs/controllers/basicController.dart';
import 'package:findjobs/controllers/educationController.dart';
import 'package:findjobs/controllers/jobroleController.dart';
import 'package:findjobs/controllers/locationController.dart';
import 'package:findjobs/controllers/profileController.dart';
import 'package:findjobs/controllers/skillsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.put(ProfileController());
  final basicDetailsController = Get.put(BasicDetailsController());
  final educationDetailsController = Get.put(EducationDetailsController());
  final locationController = Get.put(LocationController());
  final skillsController = Get.put(SkillsController());
  final jobRoleController = Get.put(JobRoleController());
  // Initial text
  String _text =
      'Passionate software engineer with 5+ years of experience in mobile development. Specialized in Flutter and native Android development';
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _editText() {
    setState(() {
      _text = _controller.text;
    });
  }

  File? _profileImage;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
    Get.back(); // Close the bottom sheet
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = profileController.profile.value!;

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Get.back(),
              ),
              expandedHeight: Get.height * .24,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  basicDetailsController.name.value,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                background: Container(
                  decoration: const BoxDecoration(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 42),
                      GestureDetector(
                        onTap: _showImageSourceSheet,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : NetworkImage(profile.avatarUrl)
                                  as ImageProvider,
                          child: _profileImage == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey,
                                  size: 30,
                                )
                              : null,
                        ),
                      ),
                      SizedBox(height: Get.height * .07),
                      Text(
                        jobRoleController.selectedJobRoles.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                centerTitle: true, // Center the title in the app bar
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          const Spacer(),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.edit))
                        ],
                      ),
                    ),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            _buildInfoRow(Icons.location_on,
                                locationController.selectedCity.value),
                            const Divider(),
                            _buildInfoRow(Icons.email,
                                basicDetailsController.email.value),
                            const Divider(),
                            _buildInfoRow(Icons.phone,
                                basicDetailsController.phone.value),
                            const Divider(),
                            _buildInfoRow(Icons.link, profile.linkedin),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Bio
                    Container(
                      child: Row(
                        children: [
                          const Text(
                            'About',
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                            softWrap:
                                true, // Allows the text to wrap to multiple lines
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              // Show dialog to edit text
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Edit About'),
                                    content: TextField(
                                      controller: _controller,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter your text here...',
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Save the text and close dialog
                                          _editText();
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Save'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          // Close dialog without saving
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: const Text(
                        'Passionate software engineer with 5+ years of experience in mobile development. Specialized in Flutter and native Android development',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),

                    // Skills
                    _buildSection(
                      'Skills',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: skillsController.selectedSkills.map((skill) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(skill
                                    .toString()), // Display the skill name here
                                const SizedBox(width: 4),
                                // Uncomment if skill.level is available and needed
                                // Row(
                                //   mainAxisSize: MainAxisSize.min,
                                //   children: List.generate(
                                //     5,
                                //     (index) => Icon(
                                //       Icons.circle,
                                //       size: 8,
                                //       color: index < skill.level
                                //           ? Colors.blue[800]
                                //           : Colors.blue[200],
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Experience
                    _buildSection(
                      'Experience',
                      child: Column(
                        children: profile.experience.map((exp) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    exp.company,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    exp.position,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    exp.duration,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(exp.description),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // Education
                    _buildSection(
                      'Education',
                      child: Column(
                        children: profile.education.map((edu) {
                          return Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    edu.school,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    edu.degree,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    edu.duration,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to edit profile
          Get.snackbar(
            'Edit Profile',
            'Edit profile functionality coming soon!',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildSection(String title, {required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        child,
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[800]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
