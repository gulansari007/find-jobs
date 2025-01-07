import 'package:findjobs/modals/notifications_modal.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NotificationController extends GetxController {
  var notificationTitle = ''.obs;
  var notificationBody = ''.obs;
  var fcmToken = ''.obs;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    initializeFirebaseMessaging();
    loadNotifications();
  }

  Future<void> initializeFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else {
      print('User declined or hasn\'t accepted permission');
    }

    _firebaseMessaging.getToken().then((token) {
      fcmToken.value = token ?? '';
      print("FCM Token: $token");
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = JobNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: message.notification?.title ?? 'No Title',
        message: message.notification?.body ?? 'No Body',
        timestamp: DateTime.now(),
        type: NotificationType.systemUpdate,
        isRead: false,
      );
      addNotification(notification);
      print("Message received: ${message.notification?.title}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationTitle.value = message.notification?.title ?? '';
      notificationBody.value = message.notification?.body ?? '';
      print("Notification opened: ${message.notification?.title}");
    });
  }

  final RxList<JobNotification> _notifications = RxList<JobNotification>();

  List<JobNotification> get notifications => _notifications;

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAsRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
      saveNotifications();
    }
  }

  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n.id == id);
    saveNotifications();
  }

  void openNotification(int id) {
    final notification = _notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => JobNotification(
        id: -1,
        title: 'Notification Not Found',
        message: 'This notification does not exist.',
        timestamp: DateTime.now(),
        type: NotificationType.systemUpdate,
        isRead: true,
      ),
    );

    if (notification.id != -1) {
      markAsRead(id);
      print("Opened notification: ${notification.title}");
    } else {
      print("Notification with id $id not found.");
    }
  }

  void addNotification(JobNotification notification) {
    _notifications.add(notification);
    saveNotifications();
  }

  Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsJson = _notifications.map((n) => n.toJson()).toList();
    await prefs.setString('notifications', jsonEncode(notificationsJson));
  }

  Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsString = prefs.getString('notifications');

    if (notificationsString != null) {
      final List<dynamic> notificationsJson = jsonDecode(notificationsString);
      _notifications.addAll(
        notificationsJson
            .map((json) => JobNotification.fromJson(json))
            .toList(),
      );
    }
  }
}

class JobNotification {
  final int id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? jobTitle;
  final String? companyName;

  JobNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    required this.isRead,
    this.jobTitle,
    this.companyName,
  });

  String get formattedTime => DateFormat('hh:mm a').format(timestamp);

  JobNotification copyWith({
    int? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? jobTitle,
    String? companyName,
  }) {
    return JobNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.toString().split('.').last,
      'isRead': isRead,
      'jobTitle': jobTitle,
      'companyName': companyName,
    };
  }

  static JobNotification fromJson(Map<String, dynamic> json) {
    return JobNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      timestamp: DateTime.parse(json['timestamp']),
      type: NotificationType.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
      ),
      isRead: json['isRead'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
    );
  }
}

enum NotificationType {
  applicationStatus,
  interview,
  recommendation,
  systemUpdate,
}
