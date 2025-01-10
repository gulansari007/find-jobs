import 'package:findjobs/controllers/notificationController.dart';
import 'package:findjobs/hive_services/hive_modal.dart';
import 'package:findjobs/screens/splash_screen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/adapters.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Ensure Firebase is initialized
  print('Handling a background message: ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<BasicDetailsModel>('basicDetails');
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await FirebaseMessaging.instance.subscribeToTopic('sample');

  Get.put(NotificationController());
  await GetStorage.init();
  runApp(const MyApp());
}

// void initializeAppCheck() async {
//   await Firebase.initializeApp();

//   // Enable App Check with the default provider for development
//   await FirebaseAppCheck.instance.activate(
//     webRecaptchaSiteKey: '', // Replace with your reCAPTCHA key for web
//   );
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
        theme: ThemeData(useMaterial3: true));
  }
}
