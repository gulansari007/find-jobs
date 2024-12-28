import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  final storage = GetStorage();
  
  final pushNotifications = true.obs;
  final emailNotifications = true.obs;
  final jobDistance = 50.obs;
  final darkMode = false.obs;
  final selectedJobTypes = <String>{}.obs;
  
  final jobTypes = ['Full-time', 'Part-time', 'Contract', 'Internship'];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() {
    pushNotifications.value = storage.read('pushNotifications') ?? true;
    emailNotifications.value = storage.read('emailNotifications') ?? true;
    jobDistance.value = storage.read('jobDistance') ?? 50;
    darkMode.value = storage.read('darkMode') ?? false;
    selectedJobTypes.value = (storage.read('selectedJobTypes')?.cast<String>() ?? {'Full-time'}).toSet();
  }

  void saveSettings() {
    storage.write('pushNotifications', pushNotifications.value);
    storage.write('emailNotifications', emailNotifications.value);
    storage.write('jobDistance', jobDistance.value);
    storage.write('darkMode', darkMode.value);
    storage.write('selectedJobTypes', selectedJobTypes.toList());
  }

  void toggleJobType(String type) {
    if (selectedJobTypes.contains(type)) {
      if (selectedJobTypes.length > 1) {
        selectedJobTypes.remove(type);
      }
    } else {
      selectedJobTypes.add(type);
    }
    saveSettings();
  }
}