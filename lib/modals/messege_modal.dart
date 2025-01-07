class Reply {
  final String id;
  final String message;
  final String time;
  final bool isFromMe;

  Reply({
    required this.id,
    required this.message,
    required this.time,
    required this.isFromMe,
  });
}

class Message {
  final String id;
  final String senderName;
  final String lastMessage;
  final String time;
  final String avatarUrl;
  bool unread;
  final List<Reply> replies;

  Message({
    required this.id,
    required this.senderName,
    required this.lastMessage,
    required this.time,
    required this.avatarUrl,
    this.unread = false,
    this.replies = const [],
  });

  static fromJson(data) {}

  static void fromMap(Map<String, dynamic> data) {}
}