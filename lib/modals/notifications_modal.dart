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
    this.isRead = false,
    this.jobTitle,
    this.companyName,
  });
}

// Notification Type Enum
enum NotificationType {
  applicationStatus,
  newJobMatch,
  interview,
  recommendation,
  systemUpdate
}