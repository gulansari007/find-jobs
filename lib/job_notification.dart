import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobFire extends StatefulWidget {
  const JobFire({super.key});

  @override
  State<JobFire> createState() => _JobFireState();
}

class _JobFireState extends State<JobFire> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _activeCommentPostId;

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  void _showComments(String postId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (_, controller) {
            return Column(
              children: [
                const SizedBox(height: 10),
                const Text(
                  'Comments',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final comments = snapshot.data?.docs ?? [];

                      if (comments.isEmpty) {
                        return const Center(child: Text('No comments yet.'));
                      }

                      return ListView.builder(
                        controller: controller,
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final commentData =
                              comments[index].data() as Map<String, dynamic>;
                          final String userName =
                              commentData['userName'] ?? 'Anonymous';
                          final String comment = commentData['comment'] ?? '';
                          final Timestamp? timestamp = commentData['timestamp'];
                          final String timeAgo = timestamp != null
                              ? timeago.format(timestamp.toDate())
                              : 'Unknown time';

                          return ListTile(
                            title: Text(userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(comment),
                            trailing: Text(
                              timeAgo,
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final posts = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final data = post.data() as Map<String, dynamic>;

              final String postId = post.id;
              final String userId = data['userId'] ?? '';
              final String userName = data['userName'] ?? 'Unknown User';
              final String userProfileImage = data['userProfileImage'] ??
                  'https://www.example.com/default_profile_image.png';
              final String jobTitle = data['jobTitle'] ?? 'No title provided';
              final String? mediaUrl = data['mediaUrl'];
              final int likeCount = data['likes'] ?? 0;
              final List<dynamic> likedBy = data['likedBy'] ?? [];
              final Timestamp? timestamp = data['timestamp'];

              bool isLiked = likedBy.contains(currentUser?.uid);

              // Format timestamp using timeago
              String timeAgo = timestamp != null
                  ? timeago.format(timestamp.toDate())
                  : 'Unknown time';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(userProfileImage),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                userName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                timeAgo,
                                style: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                              if (currentUser?.uid == userId)
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    final confirmDelete =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Post'),
                                        content: const Text(
                                            'Are you sure you want to delete this post?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmDelete == true) {
                                      await FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(postId)
                                          .delete();
                                    }
                                  },
                                ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Job Title
                      Text(
                        jobTitle,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),

                      // Media (if available)
                      if (mediaUrl != null && mediaUrl.isNotEmpty)
                        mediaUrl.endsWith('.mp4')
                            ? const Icon(Icons.play_circle_fill, size: 150)
                            : Image.network(
                                mediaUrl,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Text('Failed to load media');
                                },
                              ),
                      const SizedBox(height: 10),

                      // Like, Comment, Share Buttons
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              isLiked ? Icons.thumb_up : Icons.thumb_up_off_alt,
                              color: isLiked ? Colors.blue : Colors.grey,
                            ),
                            onPressed: () async {
                              if (isLiked) {
                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(post.id)
                                    .update({
                                  'likes': FieldValue.increment(-1),
                                  'likedBy': FieldValue.arrayRemove(
                                      [currentUser?.uid]),
                                });
                              } else {
                                await FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(post.id)
                                    .update({
                                  'likes': FieldValue.increment(1),
                                  'likedBy':
                                      FieldValue.arrayUnion([currentUser?.uid]),
                                });
                              }
                            },
                          ),
                          Text('$likeCount likes'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.comment),
                            onPressed: () {
                              setState(() {
                                if (_activeCommentPostId == postId) {
                                  _activeCommentPostId = null;
                                  FocusScope.of(context).unfocus();
                                } else {
                                  _activeCommentPostId = postId;
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    FocusScope.of(context)
                                        .requestFocus(_commentFocusNode);
                                  });
                                }
                              });
                            },
                          ),
                          const Text('comment'),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              Share.share(
                                  'Check out this job: $jobTitle\n$mediaUrl');
                            },
                          ),
                          const Text('share')
                        ],
                      ),

                      // Comment TextField (Visible when the post is selected)
                      if (_activeCommentPostId == postId)
                        Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              focusNode: _commentFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    final comment =
                                        _commentController.text.trim();
                                    if (comment.isNotEmpty) {
                                      // Add the comment to Firestore under the correct post with user info
                                      await FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(post.id)
                                          .collection('comments')
                                          .add({
                                        'postId': post.id,
                                        'comment': comment,
                                        'userName': currentUser?.displayName ??
                                            'Anonymous',
                                        'userProfileImage': currentUser
                                                ?.photoURL ??
                                            'https://www.example.com/default_profile_image.png',
                                        'timestamp':
                                            FieldValue.serverTimestamp(),
                                      });
                                      _commentController.clear();
                                      setState(() {
                                        _activeCommentPostId =
                                            null; // Close the comment input field
                                      });
                                      FocusScope.of(context)
                                          .unfocus(); // Close the keyboard
                                    }
                                  },
                                  icon: const Icon(Icons.send_outlined),
                                ),
                              ),
                              onSubmitted: (comment) async {
                                if (comment.isNotEmpty) {
                                  // Add the comment to Firestore under the correct post with user info
                                  await FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(post.id)
                                      .collection('comments')
                                      .add({
                                    'postId': post.id,
                                    'comment': comment,
                                    'userName':
                                        currentUser?.displayName ?? 'Anonymous',
                                    'userProfileImage': currentUser?.photoURL ??
                                        'https://www.example.com/default_profile_image.png',
                                    'timestamp': FieldValue.serverTimestamp(),
                                  });
                                  _commentController.clear();
                                  setState(() {
                                    _activeCommentPostId =
                                        null; // Close the comment input field
                                  });
                                  FocusScope.of(context)
                                      .unfocus(); // Close the keyboard
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),

                      // See All Comments Button
                      TextButton(
                        onPressed: () {
                          _showComments(postId);
                        },
                        child: const Text('See All Comments'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
