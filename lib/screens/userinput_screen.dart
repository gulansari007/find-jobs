import 'dart:io';
import 'package:findjobs/controllers/basicController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findjobs/controllers/userinputController.dart';
import 'package:image_picker/image_picker.dart';

class UserInputScreen extends StatefulWidget {
  const UserInputScreen({Key? key}) : super(key: key);

  @override
  _UserInputScreenState createState() => _UserInputScreenState();
}

class _UserInputScreenState extends State<UserInputScreen> {
  final userInputController = Get.put(UserInputController());
  final basicDetailsController = Get.put(BasicDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Create post',
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send_rounded, color: Get.theme.primaryColor),
            onPressed: () {
              userInputController.submitPost();
              Get.back();
              Get.snackbar('Success', 'Post created successfully');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile and Name Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                        'https://www.example.com/profile_pic.png'), // Replace with actual profile picture
                  ),
                  const SizedBox(width: 10),
                  Text(
                    basicDetailsController.name.value,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Post Content Text Field (Multi-line, no border)
              TextField(
                controller: userInputController.jobTitleController,
                maxLines: 8,
                minLines: 1,
                decoration: const InputDecoration(
                  hintText: 'What do you want to talk about?',
                  border: InputBorder.none, // No border
                ),
              ),
              const SizedBox(height: 24),

              // Expanded widget to push icons to the bottom
              Expanded(child: Container()),

              // Display the selected media (image/video)
              Obx(
                () => userInputController.selectedMedia.value != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 200,
                            child: userInputController.selectedMedia.value!.path
                                    .endsWith(".mp4")
                                ? // Display video thumbnail for video file
                                const Icon(Icons.play_circle_fill,
                                    size: 200, color: Colors.grey)
                                : Image.file(
                                    userInputController.selectedMedia.value!),
                          ),
                          TextButton(
                            onPressed: userInputController.clearMedia,
                            child: const Text('Remove Media',
                                style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
                    : const SizedBox
                        .shrink(), // Show nothing if no media is selected
              ),

              // Stack to position icons at bottom-right corner
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Add Image Icon
                  IconButton(
                    icon: Icon(Icons.image, color: Get.theme.primaryColor),
                    onPressed: () => userInputController.pickMedia(true),
                    tooltip: 'Add Image/Photo',
                  ),
                  // Add Video Icon
                  IconButton(
                    icon: Icon(Icons.video_library,
                        color: Get.theme.primaryColor),
                    onPressed: () => userInputController.pickMedia(false),
                    tooltip: 'Add Video',
                  ),
                  // More Options Button
                  IconButton(
                    icon: Icon(Icons.more_vert, color: Get.theme.primaryColor),
                    onPressed: () => _showMoreOptionsBottomSheet(context),
                    tooltip: 'More Options',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Bottom sheet to display more options (media types, etc.)
  void _showMoreOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBottomSheetOption(Icons.camera_outlined, 'Camera', () {
              userInputController.captureMediaFromCamera(true);
            }),
            _buildBottomSheetOption(Icons.photo_outlined, 'Photos',
                () => userInputController.pickMedia(true)),
            _buildBottomSheetOption(Icons.video_library_outlined, 'Videos',
                () => userInputController.pickMedia(false)),
            _buildBottomSheetOption(Icons.work_outline_outlined, 'Job', () {}),
            _buildBottomSheetOption(Icons.event_outlined, 'Event', () {}),
            _buildBottomSheetOption(
                Icons.celebration_outlined, 'Celebrate', () {}),
            _buildBottomSheetOption(
                Icons.document_scanner_outlined, 'Document', () {}),
          ],
        ),
      ),
    );
  }

  // Helper method to build a bottom sheet option
  Widget _buildBottomSheetOption(
      IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Get.theme.primaryColor),
      title: Text(label),
      onTap: onTap,
    );
  }
}
