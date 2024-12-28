import 'package:findjobs/controllers/homeController.dart';
import 'package:findjobs/screens/chat.dart';
import 'package:findjobs/screens/chat_login.dart';
import 'package:findjobs/screens/help_support_screen.dart';
import 'package:findjobs/screens/messeges_screen.dart';
import 'package:findjobs/screens/saved_jobs_screen.dart';
import 'package:findjobs/screens/settings_screen.dart';
import 'package:findjobs/screens/upload_screen.dart';
import 'package:findjobs/screens/userinput_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[100],
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
                  backgroundColor: Colors.grey[200],
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
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                decoration: BoxDecoration(),
                accountName: Text(
                  'Gul Ansarii',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                accountEmail: Text(
                  'johndoe@example.com',
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/find.jpg'),
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
                  Navigator.pushNamed(context, '/profile');
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
                  // Add logout logic here
                  // For example:
                  // AuthService.logout();
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
                        Text(
                          'Featured Jobs',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(const UploadScreen());
                          },
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildFeaturedJobCard(
                      companyLogo: 'G',
                      companyName: 'Google',
                      jobTitle: 'Senior Flutter Developer',
                      location: 'New Delhi',
                      salary: '\$120k - \$180k/year',
                      tags: ['Remote', 'Full Time'],
                    ),
                    const SizedBox(height: 16),
                    _buildFeaturedJobCard(
                      companyLogo: 'M',
                      companyName: 'Microsoft',
                      jobTitle: 'Software Engineer',
                      location: 'Noida',
                      salary: '\$110k - \$170k/year',
                      tags: ['On-site', 'Full Time'],
                    ),
                  ],
                ),
              ),

              // Recommended Jobs Section
              Padding(
                padding: const EdgeInsets.all(16),
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
                    _buildRecommendedJobCard(
                      companyName: 'Apple',
                      jobTitle: 'iOS Developer',
                      location: 'Banglore',
                      postedTime: '2 hours ago',
                      salary: '\$100k - \$150k/year',
                    ),
                    const SizedBox(height: 12),
                    _buildRecommendedJobCard(
                      companyName: 'Amazon',
                      jobTitle: 'Full Stack Developer',
                      location: 'New York, NY',
                      postedTime: '5 hours ago',
                      salary: '\$90k - \$140k/year',
                    ),
                    const SizedBox(height: 12),
                    _buildRecommendedJobCard(
                      companyName: 'Meta',
                      jobTitle: 'React Native Developer',
                      location: 'Remote',
                      postedTime: '1 day ago',
                      salary: '\$95k - \$145k/year',
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
