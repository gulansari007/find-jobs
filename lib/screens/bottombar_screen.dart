import 'package:animations/animations.dart';
import 'package:findjobs/controllers/notificationController.dart';
import 'package:findjobs/screens/jobs_screen.dart';
import 'package:findjobs/screens/messeges_screen.dart';
import 'package:findjobs/screens/notifications_screen.dart';
import 'package:findjobs/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  final notificationController = Get.put(NotificationController());
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const JobScreen(),
    const NotificationScreen(),
    const ProfileScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return FadeThroughTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade700,
        showUnselectedLabels: true,
        selectedItemColor: Get.theme.primaryColor,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
              icon: Obx(
                () => Stack(
                  children: [
                    const Icon(
                        Icons.notifications_outlined), // Base notification icon
                    if (notificationController.unreadCount >
                        0) // Only show badge if count > 0
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red, // Badge background color
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 12,
                            minHeight: 12,
                          ),
                          child: Text(
                            '${notificationController.unreadCount}', // Display unread count
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: 'Notifications', // Add a label for better UX
              activeIcon: const Icon(Icons.notifications)),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          // const BottomNavigationBarItem(
          //   icon: Icon(Icons.restaurant_menu),
          //   label: 'Profile',
          // ),
        ],
      ),
    );
  }
}
