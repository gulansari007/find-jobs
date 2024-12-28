import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HelpsupportScreen extends StatefulWidget {
  const HelpsupportScreen({super.key});

  @override
  State<HelpsupportScreen> createState() => _HelpsupportScreenState();
}

class _HelpsupportScreenState extends State<HelpsupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for help',
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // FAQ Section
              const Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildFAQItem(
                context,
                'How do I create a strong profile?',
                'Learn tips for creating a compelling profile that attracts employers.',
              ),
              _buildFAQItem(
                context,
                'Job application status',
                'Track and understand your job application status.',
              ),
              _buildFAQItem(
                context,
                'Profile visibility settings',
                'Manage who can view your profile and application history.',
              ),
              _buildFAQItem(
                context,
                'Saved jobs management',
                'Learn how to manage and organize your saved job listings.',
              ),

              const SizedBox(height: 24),

              // Contact Support Section
              const Text(
                'Contact Support',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildContactOption(
                icon: Icons.email_outlined,
                title: 'Email Support',
                subtitle: 'Get help within 24 hours',
                onTap: () {
                  // Add email support logic
                },
              ),
              _buildContactOption(
                icon: Icons.chat_bubble_outline,
                title: 'Live Chat',
                subtitle: 'Chat with our support team',
                onTap: () {
                  // Add live chat logic
                },
              ),
              _buildContactOption(
                icon: Icons.phone_outlined,
                title: 'Phone Support',
                subtitle: 'Call us at +1 (555) 123-4567',
                onTap: () {
                  // Add phone call logic
                },
              ),

              const SizedBox(height: 24),

              // Additional Resources
              const Text(
                'Additional Resources',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildResourceCard(
                'Resume Writing Guide',
                'Learn how to create an effective resume',
                Icons.description_outlined,
              ),
              _buildResourceCard(
                'Interview Tips',
                'Prepare for your next interview',
                Icons.people_outline,
              ),
              _buildResourceCard(
                'Career Resources',
                'Access career development materials',
                Icons.work_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, String title, String description) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(description),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to FAQ detail page
        },
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, size: 28),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  Widget _buildResourceCard(String title, String description, IconData icon) {
    return SizedBox(
      width: Get.width,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
