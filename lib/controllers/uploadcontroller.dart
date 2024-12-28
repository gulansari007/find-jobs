import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class FileUploadController extends GetxController {
  final Rx<File?> selectedFile = Rx<File?>(null);
  final RxString uploadError = RxString('');
  final RxBool isUploading = RxBool(false);

  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);

        // File type validation
        final allowedExtensions = ['pdf', 'doc', 'docx'];
        final fileExtension = file.path.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(fileExtension)) {
          uploadError.value = 'Please upload a PDF or Word document.';
          selectedFile.value = null;
          return;
        }

        // File size validation (5MB limit)
        int fileSize = await file.length();
        if (fileSize > 5 * 1024 * 1024) {
          uploadError.value = 'File size should be less than 5MB.';
          selectedFile.value = null;
          return;
        }

        // If validation passes
        selectedFile.value = file;
        uploadError.value = '';
      }
    } catch (e) {
      uploadError.value = 'Error selecting file: ${e.toString()}';
    }
  }

  void removeFile() {
    selectedFile.value = null;
    uploadError.value = '';
  }

  Future<void> uploadFile() async {
    if (selectedFile.value != null) {
      try {
        // Start upload process
        isUploading.value = true;

        // TODO: Implement actual file upload logic
        // Example:
        // final response = await apiService.uploadResume(selectedFile.value);

        // Simulated delay to show loading
        await Future.delayed(const Duration(seconds: 2));

        // Success handling
        Get.snackbar(
          'Success',
          'Resume uploaded successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Reset state
        selectedFile.value = null;
      } catch (e) {
        // Error handling
        Get.snackbar(
          'Error',
          'Failed to upload resume',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isUploading.value = false;
      }
    }
  }
}
