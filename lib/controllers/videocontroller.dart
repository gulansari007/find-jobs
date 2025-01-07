import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class VideoController extends GetxController {


 final DatabaseReference dbRef = FirebaseDatabase.instance.ref('mediaData');

  Future<void> uploadMedia() async {
    // Pick a file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media, // FileType can be .image, .video, or .audio
    );

    if (result != null) {
      final file = result.files.first;
      final fileName = file.name;
      final filePath = file.path;

      if (filePath != null) {
        try {
          // Upload to Firebase Storage
          final storageRef = FirebaseStorage.instance.ref().child('media/$fileName');
          final uploadTask = await storageRef.putFile(File(filePath));

          // Get download URL
          final downloadURL = await uploadTask.ref.getDownloadURL();

          // Save metadata to Realtime Database
          await dbRef.push().set({
            'name': fileName,
            'url': downloadURL,
            'type': file.extension, // Save the file type
            'uploadedAt': DateTime.now().toIso8601String(),
          });

          print('Media uploaded successfully!');
        } catch (e) {
          print('Error uploading media: $e');
        }
      }
    }
  }





  // var videoUrls = <String>[].obs; // Observable list for video URLs
  // var isLoading = false.obs; // Observable loading state

  // // Fetch videos from Firestore
  // Future<void> fetchVideos() async {
  //   try {
  //     isLoading(true); // Set loading state to true
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('videos').get();
  //     videoUrls.value =
  //         snapshot.docs.map((doc) => doc['videoUrl'] as String).toList();
  //   } catch (e) {
  //     print('Error fetching videos: $e');
  //   } finally {
  //     isLoading(false); // Set loading state to false
  //   }
  // }

  // uploadVideo(String path) {}
  // var videoUrls = <String>[].obs; // Observable list for video URLs
  // var isLoading = false.obs; // Loading state for video uploads

  // // Fetch video URLs from Firestore
  // Future<void> fetchVideos() async {
  //   try {
  //     isLoading(true);
  //     var snapshot =
  //         await FirebaseFirestore.instance.collection('videos').get();
  //     videoUrls.value =
  //         snapshot.docs.map((doc) => doc['videoUrl'] as String).toList();
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  // // Upload video and save its URL to Firestore
  // Future<void> uploadVideo(String videoPath) async {
  //   try {
  //     isLoading(true);
  //     final file = File(videoPath);
  //     final storageRef =
  //         FirebaseStorage.instance.ref().child('videos/${DateTime.now()}.mp4');
  //     await storageRef.putFile(file);
  //     final videoUrl = await storageRef.getDownloadURL();

  //     // Save video URL to Firestore
  //     final user = FirebaseAuth.instance.currentUser;
  //     await FirebaseFirestore.instance.collection('videos').add({
  //       'videoUrl': videoUrl,
  //       'userId': user?.uid,
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     // Fetch the updated video list
  //     fetchVideos();
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  // var isUploading = false.obs; // Reactive variable to track upload status

  // final FirebaseStorage _storage = FirebaseStorage.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final ImagePicker _picker = ImagePicker();

  // // Method to pick a video from the gallery or camera
  // Future<void> pickAndUploadVideo() async {
  //   try {
  //     isUploading(true); // Set uploading state to true

  //     // Pick video from gallery
  //     final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
  //     if (video == null) {
  //       Get.snackbar("Error", "No video selected.");
  //       return;
  //     }

  //     // Upload video to Firebase Storage
  //     File videoFile = File(video.path);
  //     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  //     Reference storageRef = _storage.ref().child('videos/$fileName');

  //     // Upload the video
  //     await storageRef.putFile(videoFile);

  //     // Get the download URL of the uploaded video
  //     String videoUrl = await storageRef.getDownloadURL();

  //     // Store video metadata (URL, likes, and comments) in Firestore
  //     await _firestore.collection('videos').add({
  //       'videoUrl': videoUrl,
  //       'likes': 0, // Initialize likes to 0
  //       'comments': [], // Initialize comments as an empty list
  //       'timestamp': FieldValue.serverTimestamp(),
  //     });

  //     Get.snackbar("Success", "Video uploaded successfully!");
  //   } catch (e) {
  //     Get.snackbar("Error", "Video upload failed. Please try again.");
  //     print("Error uploading video: $e");
  //   } finally {
  //     isUploading(false); // Set uploading state to false
  //   }
  // }
}
