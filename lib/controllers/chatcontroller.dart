import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Reactive variables
  var messages = <Map<String, dynamic>>[].obs;
  var messageText = ''.obs;
  

  @override
  void onInit() {
    super.onInit();
    fetchMessages();
  }

  void fetchMessages() {
    _firestore
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => {
                'text': doc['text'],
                'sender': doc['sender'],
                'timestamp': doc['timestamp']
              })
          .toList();
    });
  }

  void sendMessage(String sender) {
    if (messageText.value.trim().isNotEmpty) {
      _firestore.collection('messages').add({
        'text': messageText.value,
        'sender': sender,
        'timestamp': FieldValue.serverTimestamp(),
      });
      messageText.value = '';
    }
  }
}
