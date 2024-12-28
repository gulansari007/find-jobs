import 'package:findjobs/modals/messege_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController {
  TextEditingController recipientController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  var messages = <Message>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
  }

  void loadMessages() {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      messages.value = [
        Message(
          id: '1',
          senderName: "John Smith",
          lastMessage: "Thanks for applying! When can you start?",
          time: "10:30 AM",
          avatarUrl: "https://placeholder.com/150",
          unread: true,
          replies: [
            Reply(
              id: '1',
              message: "I can start from next Monday",
              time: "10:35 AM",
              isFromMe: true,
            ),
            Reply(
              id: '2',
              message: "Perfect! I'll send you the details.",
              time: "10:40 AM",
              isFromMe: false,
            ),
          ],
        ),
        Message(
          id: '2',
          senderName: "Tech Solutions Inc.",
          lastMessage: "Your application has been received",
          time: "9:15 AM",
          avatarUrl: "https://placeholder.com/150",
        ),
        Message(
          id: '3',
          senderName: "Sarah Williams",
          lastMessage: "Let's schedule an interview for next week",
          time: "Yesterday",
          avatarUrl: "https://placeholder.com/150",
          unread: true,
        ),
      ];
      isLoading.value = false;
    });
  }

    void addReply(String messageId, String replyText) {
    final index = messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      final message = messages[index];
      final newReply = Reply(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: replyText,
        time: "Just now",
        isFromMe: true,
      );
      
      final updatedReplies = [...message.replies, newReply];
      messages[index] = Message(
        id: message.id,
        senderName: message.senderName,
        lastMessage: message.lastMessage,
        time: message.time,
        avatarUrl: message.avatarUrl,
        unread: false,
        replies: updatedReplies,
      );
      messages.refresh();
    }
  }

  List<Message> get filteredMessages {
    return messages
        .where((message) =>
            message.senderName
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()) ||
            message.lastMessage
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void markAsRead(String messageId) {
    final index = messages.indexWhere((message) => message.id == messageId);
    if (index != -1) {
      messages[index].unread = false;
      messages.refresh();
    }
  }

  void deleteMessage(String messageId) {
    messages.removeWhere((message) => message.id == messageId);
  }
  void toggleReadStatus(String messageId) {
  final index = messages.indexWhere((message) => message.id == messageId);
  if (index != -1) {
    messages[index].unread = !messages[index].unread; // Toggle the status
    messages.refresh(); // Notify the UI of the update
  }
}
}


  // var messages = [].obs;
  // var isLoading = false.obs;
  // var searchQuery = ''.obs;

  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // void loadMessages(String currentUserId) {
  //   isLoading.value = true;
  //   _firestore
  //       .collection('messages')
  //       .where('senderId', isEqualTo: currentUserId)
  //       .snapshots()
  //       .listen((snapshot) {
  //     messages.value = snapshot.docs
  //         .map((doc) => {
  //               'id': doc.id,
  //               'senderId': doc['senderId'],
  //               'receiverId': doc['receiverId'],
  //               'message': doc['message'],
  //               'timestamp': doc['timestamp'],
  //               'isRead': doc['isRead'],
  //             })
  //         .toList();
  //     isLoading.value = false;
  //   });
  // }

  // void sendMessage(String senderId, String receiverId, String text) {
  //   _firestore.collection('messages').add({
  //     'senderId': senderId,
  //     'receiverId': receiverId,
  //     'message': text,
  //     'timestamp': FieldValue.serverTimestamp(),
  //     'isRead': false,
  //   });
  // }

  // void markAsRead(String messageId) {
  //   _firestore.collection('messages').doc(messageId).update({'isRead': true});
  // }