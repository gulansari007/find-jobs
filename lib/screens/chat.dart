import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findjobs/controllers/chatcontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key, required String chatId});

  @override
  State<ChatListScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatListScreen> {
  final chatController = Get.put(ChatController());
  final chatIds = ['chat1', 'chat2', ''];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: ListView.builder(
        itemCount: chatIds.length,
        itemBuilder: (context, index) {
          final chatId = chatIds[index];
          return ListTile(
            title: Text('Chat $index'),
            subtitle: Text(chatId.isNotEmpty ? chatId : 'Invalid ID'),
            onTap: () {
              if (chatId.isNotEmpty) {
                Get.to(() => ChatScreen(chatId: chatId));
              } else {
                Get.snackbar('Error', 'Chat ID is empty, cannot open chat.');
              }
            },
          );
        },
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String chatId;

  const ChatScreen({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    if (chatId.isEmpty) {
      // Display error UI for invalid chat ID.
      return Scaffold(
        appBar: AppBar(title: const Text('Invalid Chat')),
        body: const Center(
          child: Text('Chat ID is invalid or missing.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No messages yet.'));
          }

          final messages = snapshot.data!.docs;

          return ListView.builder(
            reverse: true,
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Text(message['text'] ?? 'No Text'),
                subtitle: Text(
                  message['sender'] ?? 'Unknown Sender',
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: MessageInput(chatId: chatId),
    );
  }
}

class MessageInput extends StatefulWidget {
  final String chatId;

  const MessageInput({Key? key, required this.chatId}) : super(key: key);

  @override
  _MessageInputState createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
      'text': _controller.text.trim(),
      'sender': 'User', // Replace with actual sender
      'timestamp': FieldValue.serverTimestamp(),
    });

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
