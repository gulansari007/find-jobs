import 'package:findjobs/modals/notifications_modal.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
  var notificationTitle = ''.obs;
  var notificationBody = ''.obs;
  var fcmToken = ''.obs;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    initializeFirebaseMessaging();
  }

  Future<void> initializeFirebaseMessaging() async {
    // Request permission for notifications
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

    // Retrieve FCM token
    _firebaseMessaging.getToken().then((token) {
      fcmToken.value = token ?? '';
      print("FCM Token: $token");
    });

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = JobNotification(
        id: DateTime.now().millisecondsSinceEpoch,
        title: message.notification?.title ?? 'No Title',
        message: message.notification?.body ?? 'No Body',
        timestamp: DateTime.now(),
        type: NotificationType.systemUpdate, // Assign a default type
        isRead: false, // Unread by default
      );
      addNotification(notification);
      print("Message received: ${message.notification?.title}");
    });

    // Handle background notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      notificationTitle.value = message.notification?.title ?? '';
      notificationBody.value = message.notification?.body ?? '';
      print("Notification opened: ${message.notification?.title}");
    });
  }

  // Observable list of notifications
  final RxList<JobNotification> _notifications = RxList<JobNotification>();

  // Getters
  List<JobNotification> get notifications => _notifications;

  // Computed property for unread count
  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  // Mark a notification as read
  void markAsRead(int id) {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(isRead: true);
    }
  }

  // Delete a notification
  void deleteNotification(int id) {
    _notifications.removeWhere((n) => n.id == id);
  }

  // Open a notification (e.g., navigate to details)
  void openNotification(int id) {
    final notification = _notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => JobNotification(
        id: -1, // Fallback ID for non-existent notifications
        title: 'Notification Not Found',
        message: 'This notification does not exist.',
        timestamp: DateTime.now(),
        type: NotificationType.systemUpdate, // Default type for fallback
        isRead: true,
      ),
    );

    // Check if the fallback notification was used
    if (notification.id != -1) {
      markAsRead(id);
      // Add your navigation or opening logic here
      print("Opened notification: ${notification.title}");
    } else {
      print("Notification with id $id not found.");
    }
  }

  // Add a new notification (for testing or receiving a push)
  void addNotification(JobNotification notification) {
    _notifications.add(notification);
  }
}

// JobNotification model
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

  // Format time for display
  String get formattedTime {
    return DateFormat('hh:mm a').format(timestamp);
  }

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
}

// NotificationType enum
enum NotificationType {
  applicationStatus,
  interview,
  recommendation,
  systemUpdate,
}
