import 'package:findjobs/controllers/videocontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UploadVideoScreen extends StatefulWidget {
  const UploadVideoScreen({super.key});

  @override
  State<UploadVideoScreen> createState() => _UploadVideoScreenState();
}

class _UploadVideoScreenState extends State<UploadVideoScreen> {
  final videoController = Get.put(VideoController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload reel'),
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: videoController.uploadMedia,
        child: const Text('Pick and Upload Video'),
      )),
    );
  }
}
