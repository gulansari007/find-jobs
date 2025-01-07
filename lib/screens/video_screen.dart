import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findjobs/controllers/videocontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final videoController = Get.put(VideoController());
  @override
  Widget build(BuildContext context) {
    // videoController.fetchVideos();
    return Scaffold(
      appBar: AppBar(title: const Text('Reels')),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('videos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No videos available.'));
          }

          final videoDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: videoDocs.length,
            itemBuilder: (context, index) {
              var videoData = videoDocs[index];
              return VideoPlayerWidget(videoUrl: videoData['videoUrl']);
            },
          );
        },
      ),
      // body: Obx(() {
      //   if (videoController.isLoading.value) {
      //     return const Center(child: CircularProgressIndicator());
      //   }

      //   if (videoController.videoUrls.isEmpty) {
      //     return const Center(child: Text('No videos available.'));
      //   }

      //   return PageView.builder(
      //     itemCount: videoController.videoUrls.length,
      //     scrollDirection: Axis.vertical,
      //     itemBuilder: (context, index) {
      //       return VideoPlayerWidget(
      //           videoUrl: videoController.videoUrls[index]);
      //     },
      //   );
      // }),
    );
  }
}

// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;

//   const VideoPlayerWidget({super.key, required this.videoUrl});

//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }

// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;

//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//         _controller.play();
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return _controller.value.isInitialized
//         ? AspectRatio(
//             aspectRatio: _controller.value.aspectRatio,
//             child: VideoPlayer(_controller),
//           )
//         : const Center(child: CircularProgressIndicator());
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller.dispose();
//   }
// }

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({super.key, required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          )
        : const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
