import 'package:findjobs/controllers/settingsController.dart';
import 'package:findjobs/controllers/themeController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settingsController = Get.put(SettingsController());
  final themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
        ),
        elevation: 0,
      ),
      body: Container(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            _buildSection(
              title: 'Notifications',
              icon: Icons.notifications_outlined,
              children: [
                _buildAnimatedSwitchTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive job alerts on your device',
                  value: settingsController.pushNotifications,
                  onChanged: (val) {
                    settingsController.pushNotifications.value = val;
                    settingsController.saveSettings();
                  },
                ),
                _buildAnimatedSwitchTile(
                  title: 'Email Notifications',
                  subtitle: 'Receive job alerts via email',
                  value: settingsController.emailNotifications,
                  onChanged: (val) {
                    settingsController.emailNotifications.value = val;
                    settingsController.saveSettings();
                  },
                ),
              ],
            ),
            _buildSection(
              title: 'Job Preferences',
              icon: Icons.work_outline,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Job Search Radius'),
                          Obx(() => Text(
                                '${settingsController.jobDistance.value}km',
                                style: TextStyle(
                                  color: Get.theme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      Obx(() => Slider(
                            value:
                                settingsController.jobDistance.value.toDouble(),
                            min: 0,
                            max: 100,
                            divisions: 10,
                            activeColor: Get.theme.primaryColor,
                            onChanged: (value) {
                              settingsController.jobDistance.value =
                                  value.round();
                              settingsController.saveSettings();
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
            // _buildSection(
            //   title: 'Job Types',
            //   icon: Icons.category_outlined,
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 16.0),
            //       child: Obx(() => Wrap(
            //             spacing: 8,
            //             runSpacing: 8,
            //             children: settingsController.jobTypes
            //                 .map((type) => AnimatedContainer(
            //                       duration: const Duration(milliseconds: 200),
            //                       child: FilterChip(
            //                         label: Text(type),
            //                         selected: settingsController
            //                             .selectedJobTypes
            //                             .contains(type),
            //                         selectedColor:
            //                             Get.theme.primaryColor.withOpacity(0.2),
            //                         checkmarkColor: Get.theme.primaryColor,
            //                         onSelected: (_) =>
            //                             settingsController.toggleJobType(type),
            //                       ),
            //                     ))
            //                 .toList(),
            //           )),
            //     ),
            //   ],
            // ),
            _buildSection(
              title: 'App Settings',
              icon: Icons.settings_outlined,
              children: [
                _buildAnimatedSwitchTile(
                  title: 'Dark Mode',
                  subtitle: 'Toggle dark theme',
                  value: settingsController.darkMode,
                  onChanged: (val) {
                    settingsController.darkMode.value = val;
                    settingsController.saveSettings();
                    Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
            _buildSection(
              title: 'Account',
              icon: Icons.person_outline,
              children: [
                _buildListTile(
                  title: 'Account preferences ',
                  icon: Icons.manage_accounts_outlined,
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
                _buildListTile(
                  title: 'sign in & security ',
                  icon: Icons.password_outlined,
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
                _buildListTile(
                  title: 'Clear Search History',
                  icon: Icons.history,
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Clear History'),
                        content: const Text(
                            'Are you sure you want to clear your search history?'),
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Get.back(),
                          ),
                          ElevatedButton(
                            child: const Text('Clear'),
                            onPressed: () {
                              // Implement clear history
                              Get.back();
                              Get.snackbar(
                                'Success',
                                'Search history cleared',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                _buildListTile(
                  title: 'Privacy Policy',
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => Get.toNamed('/privacy-policy'),
                ),
                _buildListTile(
                  title: 'Terms of Service',
                  icon: Icons.description_outlined,
                  onTap: () => Get.toNamed('/terms'),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Get.theme.primaryColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        ...children,
        const Divider(height: 32),
      ],
    );
  }

  Widget _buildAnimatedSwitchTile({
    required String title,
    required String subtitle,
    required RxBool value,
    required Function(bool) onChanged,
  }) {
    return Obx(() => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color:
                value.value ? Get.theme.primaryColor.withOpacity(0.05) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: SwitchListTile(
            title: Text(title),
            subtitle: Text(subtitle),
            value: value.value,
            onChanged: onChanged,
            activeColor: Get.theme.primaryColor,
          ),
        ));
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon, color: Get.theme.primaryColor),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        themeController.toggleTheme();
      },
    );
  }
}
