import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findjobs/controllers/basicController.dart';
import 'package:findjobs/controllers/homeController.dart';
import 'package:findjobs/controllers/signupController.dart';
import 'package:findjobs/job_notification.dart';
import 'package:findjobs/screens/help_support_screen.dart';
import 'package:findjobs/screens/messeges_screen.dart';
import 'package:findjobs/screens/profile_screen.dart';
import 'package:findjobs/screens/reels_screen.dart';
import 'package:findjobs/screens/saved_jobs_screen.dart';
import 'package:findjobs/screens/settings_screen.dart';
import 'package:findjobs/screens/userinput_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  final signupController = Get.put(SignupController());
  final basicDetailsController = Get.put(BasicDetailsController());
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
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Builder(
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey.shade200,
                  child: Builder(
                    builder: (context) {
                      return Icon(Icons.person_outline,
                          color: Colors.grey[800]);
                    },
                  ),
                ),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Search jobs...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                  onPressed: () {
                    Get.to(const UserInputScreen());
                  },
                  icon: const Icon(Icons.add_circle_outline)),
              IconButton(
                icon: const Icon(Icons.message_outlined),
                onPressed: () {
                  Get.to(const MessagesScreen());
                },
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Obx(
                () => UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(),
                  accountName: Text(
                    basicDetailsController.name.value,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  accountEmail: Text(
                    basicDetailsController.email.value,
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/find.jpg'),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.work_outline),
                title: const Text('Find Jobs'),
                onTap: () {
                  Navigator.pushNamed(context, '/jobs');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bookmark_outline),
                title: const Text('Saved Jobs'),
                onTap: () {
                  Get.to(const SavedJobsScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.history_outlined),
                title: const Text('Applied Jobs'),
                onTap: () {
                  Navigator.pushNamed(context, '/applied-jobs');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () {
                  Get.to(const ProfileScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined),
                title: const Text('Notifications'),
                onTap: () {
                  Navigator.pushNamed(context, '/notifications');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Get.to(const SettingsScreen());
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline),
                title: const Text('Help & Support'),
                onTap: () {
                  Get.to(const HelpsupportScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: const Text('Logout'),
                onTap: () {
                  _showLogoutlDialog();
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Categories
              Container(
                height: 50,
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildCategoryChip(
                      'All Jobs',
                    ),
                    _buildCategoryChip(
                      'Remote',
                    ),
                    _buildCategoryChip(
                      'Full Time',
                    ),
                    _buildCategoryChip(
                      'Part Time',
                    ),
                    _buildCategoryChip(
                      'Contract',
                    ),
                  ],
                ),
              ),

              // Featured Jobs Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(const JobFire());
                          },
                          child: Text(
                            'Featured Jobs',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(() => ReelsScreen());
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              // Recommended Jobs Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended for you',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                   StreamBuilder(
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
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                color: Colors.white,
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    return Obx(() {
      bool isSelected = homeController.selectedCategory.value == label;
      return Container(
        margin: const EdgeInsets.only(right: 8),
        child: FilterChip(
          label: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          selected: isSelected,
          onSelected: (bool selected) {
            homeController.selectCategory(label);
          },
          backgroundColor: Colors.white,
          selectedColor: Theme.of(context).primaryColor,
          checkmarkColor: Colors.white,
          showCheckmark: false,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      );
    });
  }

  Widget _buildFeaturedJobCard({
    required String companyLogo,
    required String companyName,
    required String jobTitle,
    required String location,
    required String salary,
    required List<String> tags,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  companyLogo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      companyName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      jobTitle,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Obx(() => Icon(
                      homeController.isBookmarked(jobTitle)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: homeController.isBookmarked(jobTitle)
                          ? Get.theme.primaryColor
                          : null,
                    )),
                onPressed: () {
                  homeController.toggleBookmark(jobTitle);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                salary,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: tags
                .map(
                  (tag) => Chip(
                    label: Text(
                      tag,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Colors.grey[100],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedJobCard({
    required String companyName,
    required String jobTitle,
    required String location,
    required String postedTime,
    required String salary,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                companyName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                postedTime,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            jobTitle,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_outlined,
                  size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                location,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              const SizedBox(width: 16),
              Icon(Icons.attach_money, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                salary,
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

_showLogoutlDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to log out?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            SignupController().logout();
            Get.back();
          },
          style: ElevatedButton.styleFrom(),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}
