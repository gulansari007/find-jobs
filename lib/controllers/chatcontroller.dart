import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findjobs/screens/chat.dart';
import 'package:findjobs/screens/chat_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  Rxn<User> firebaseUser = Rxn<User>();
  

  @override
  void onInit() {
    firebaseUser.bindStream(auth.authStateChanges());
    super.onInit();
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      var chatId;
      if (chatId.isNotEmpty) {
        Get.to(() => ChatScreen(chatId: chatId)); // Pass a valid chatId.
      } else {
        Get.snackbar('Error', 'Chat ID is empty, cannot open chat.');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  void logout() async {
    await auth.signOut();
    Get.off(() => LoginScreen());
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var messages = <DocumentSnapshot>[].obs;

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void sendMessage(String chatId, String senderId, String text) {
    final message = {
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };
    firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);
  }
  
}
