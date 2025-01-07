// Import required packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findjobs/controllers/basicController.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserInputController extends GetxController {
  final basicDetailsController = Get.put(BasicDetailsController());
  final jobTitleController = TextEditingController();
  final RxString location = ''.obs;
  final Rx<RangeValues> salaryRange = const RangeValues(20000, 80000).obs;
  final Rx<File?> selectedMedia = Rx<File?>(null);
  final RxBool isLoadingLocation = false.obs;
  final ImagePicker _picker = ImagePicker();

  var isVideo = Rx<bool>(false); // Flag to determine if media is a video
  var mediaType =
      Rx<String>(''); // Used to track media type (image, video, etc.)
  final RxString currentLocationText = ''.obs;

  // Clear selected media
  void clearMedia() {
    selectedMedia.value = null;
    isVideo.value = false;
  }

  @override
  void onClose() {
    jobTitleController.dispose();
    super.onClose();
  }

  // Get current location
  Future<void> getCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks[0];
          String locationText =
              '${place.locality}, ${place.administrativeArea}, ${place.country}';
          currentLocationText.value = locationText;
        }
      } else {
        Get.snackbar(
          'Location Access Denied',
          'Please enable location permissions in app settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Location Error',
        'Unable to retrieve location: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade500,
        colorText: Colors.white,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // Pick Media (Image/Video)
  Future<void> pickMedia(bool isImage) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    if (isImage) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    } else {
      pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    }

    if (pickedFile != null) {
      selectedMedia.value = File(pickedFile.path);
    }
  }

  // Capture Media from Camera
  Future<void> captureMediaFromCamera(bool isImage) async {
    final XFile? capturedFile;

    if (isImage) {
      capturedFile = await _picker.pickImage(source: ImageSource.camera);
    } else {
      capturedFile = await _picker.pickVideo(source: ImageSource.camera);
    }

    if (capturedFile != null) {
      selectedMedia.value = File(capturedFile.path);
      isVideo.value = !isImage; // Update media type flag
    }
  }

  void updateUserName() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String userName = user.displayName ?? "Anonymous User";
      String userProfileImage =
          user.photoURL ?? "https://www.example.com/default_profile_image.png";

      // Now you have the actual user name and profile image URL
      print("User name: $userName");
      print("Profile image: $userProfileImage");
    }
  }

  // User details

  String userProfileImage =
      "https://www.example.com/default_profile_image.png"; // Replace with actual profile URL or a default image

  // Upload Media to Firebase Storage
  Future<String?> uploadMedia(File media) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('posts/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = ref.putFile(media);
      final snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading media: $e");
      return null;
    }
  }

  // Submit Post
  Future<void> submitPost() async {
    String? mediaUrl;

    if (selectedMedia.value != null) {
      mediaUrl = await uploadMedia(selectedMedia.value!);
    }

    try {
      // Get current user
      User? user = FirebaseAuth.instance.currentUser;
      String userName = user?.displayName ?? "Anonymous User";
      String userProfileImage =
          user?.photoURL ?? "https://www.example.com/default_profile_image.png";

      await FirebaseFirestore.instance.collection('posts').add({
        'userId': FirebaseAuth.instance.currentUser?.uid,
        'jobTitle': jobTitleController.text,
        'mediaUrl': mediaUrl,
        'userName': userName, // Store username here
        'userProfileImage': userProfileImage,
        'likes': 0,
        'likedBy': [],
        'createdAt': Timestamp.now(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Post uploaded successfully');
      Get.snackbar('Success', 'Post uploaded successfully');
    } catch (e) {
      print('Error uploading post: $e');
      Get.snackbar('Error', 'Failed to upload post');
    }
  }
}
