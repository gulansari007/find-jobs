import 'package:findjobs/controllers/messegesController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../modals/messege_modal.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final messagesController = Get.put(MessagesController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Messages',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) =>
                  messagesController.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search messages',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (messagesController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final messages = messagesController.filteredMessages;
              if (messages.isEmpty) {
                return const Center(
                  child: Text('No messages found'),
                );
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Dismissible(
                    key: Key(message.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      messagesController.deleteMessage(message.id);
                      Get.snackbar(
                        'Message Deleted',
                        'Message from ${message.senderName} was deleted',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(message.avatarUrl),
                        radius: 25,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              message.senderName,
                              style: TextStyle(
                                fontWeight: message.unread
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Text(
                            message.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        message.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: message.unread
                              ? FontWeight.w500
                              : FontWeight.normal,
                          color: message.unread
                              ? Colors.black87
                              : Colors.grey[600],
                        ),
                      ),
                      onTap: () {
                        messagesController.markAsRead(message.id);
                        Get.to(() => MessageDetailScreen(message: message));
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.edit),
      // )
    );
  }
}

class MessageDetailScreen extends StatelessWidget {
  final Message message;
  final MessagesController controller = Get.find<MessagesController>();
  final TextEditingController replyController = TextEditingController();

  MessageDetailScreen({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(message.senderName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'Delete':
                  _showDeleteConfirmation(context);
                  break;
                case 'Forward':
                  _forwardMessage(context, message);
                  break;
                case 'Block':
                  _blockSender(context);
                  break;
                default:
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'Delete',
                child: Text('Delete Message'),
              ),
              const PopupMenuItem<String>(
                value: 'Forward',
                child: Text('Forward Message'),
              ),
              const PopupMenuItem<String>(
                value: 'Block',
                child: Text('Block Sender'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final currentMessage =
                  controller.messages.firstWhere((m) => m.id == message.id);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Original message
                  MessageBubble(
                    message: currentMessage.lastMessage,
                    time: currentMessage.time,
                    isFromMe: false,
                    senderName: currentMessage.senderName,
                    avatarUrl: currentMessage.avatarUrl,
                  ),
                  const SizedBox(height: 16),
                  // Replies
                  ...currentMessage.replies.map((reply) => MessageBubble(
                        message: reply.message,
                        time: reply.time,
                        isFromMe: reply.isFromMe,
                        senderName:
                            reply.isFromMe ? 'You' : currentMessage.senderName,
                        avatarUrl: currentMessage.avatarUrl,
                      )),
                ],
              );
            }),
          ),
          // Reply input field
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: replyController,
                      decoration: InputDecoration(
                        hintText: 'Type your reply...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      if (replyController.text.trim().isNotEmpty) {
                        controller.addReply(message.id, replyController.text);
                        replyController.clear();
                        FocusScope.of(context).unfocus();
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.deleteMessage(message.id);
              Navigator.of(ctx).pop();
              Get.back(); // Go back to the previous screen after deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _forwardMessage(BuildContext context, Message message) {
    // Implement forward functionality
    Get.snackbar(
      'Forward',
      'Message forwarded successfully!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _blockSender(BuildContext context) {
    // Implement block functionality
    Get.snackbar(
      'Block Sender',
      '${message.senderName} has been blocked!',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isFromMe;
  final String senderName;
  final String avatarUrl;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.time,
    required this.isFromMe,
    required this.senderName,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isFromMe) ...[
            CircleAvatar(
              backgroundImage: NetworkImage(avatarUrl),
              radius: 16,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isFromMe)
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      senderName,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isFromMe ? Colors.blue : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message,
                        style: TextStyle(
                          color: isFromMe ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          color: isFromMe ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isFromMe) const SizedBox(width: 24),
        ],
      ),
    );
  }
}





// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:findjobs/controllers/messegesController.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../modals/messege_modal.dart';

// class MessagesScreen extends StatefulWidget {
//   const MessagesScreen({super.key});

//   @override
//   State<MessagesScreen> createState() => _MessagesScreenState();
// }

// class _MessagesScreenState extends State<MessagesScreen> {
//   final messagesController = Get.put(MessagesController());
//   final currentUser = FirebaseAuth.instance.currentUser;

//   get message => null;

//   @override
//   Widget build(BuildContext context) {
//     if (currentUser != null) {
//       messagesController.loadMessages(currentUser!.uid);
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Messages'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: TextField(
//               onChanged: (value) =>
//                   messagesController.searchQuery.value = value,
//               decoration: InputDecoration(
//                 hintText: 'Search messages',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (messagesController.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               final messages = messagesController.messages;
//               if (messages.isEmpty) {
//                 return const Center(
//                   child: Text('No messages found'),
//                 );
//               }

//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundImage: NetworkImage(
//                     currentUser!.photoURL ??
//                         'https://www.gravatar.com/avatar/placeholder', // Placeholder for avatar
//                   ),
//                 ),
//                 title: Text(
//                   message['message'] ??
//                       'No message', // Ensure that the message exists, or show 'No message'
//                   style: const TextStyle(
//                       fontSize: 14), // Optional: You can adjust the style
//                 ),
//                 subtitle: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Ensure the currentUser is not null before accessing email
//                     if (currentUser != null)
//                       Text(
//                         'From: ${currentUser!.email ?? 'Unknown'}', // Display the logged-in user's email
//                         style: TextStyle(fontSize: 12, color: Colors.grey[600]),
//                       ),
//                     Text(
//                       (message['timestamp'] as Timestamp).toDate().toString(),
//                       style: TextStyle(fontSize: 12, color: Colors.grey[500]),
//                     ),
//                   ],
//                 ),
//                 onTap: () {
//                   Get.to(() => MessageDetailScreen(
//                         message: message,
//                       ));
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MessageDetailScreen extends StatelessWidget {
//   final Map<String, dynamic> message;
//   final MessagesController controller = Get.find<MessagesController>();
//   final TextEditingController replyController = TextEditingController();

//   MessageDetailScreen({Key? key, required this.message}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(message['receiverId']),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               // Display conversation
//               return ListView(
//                 padding: const EdgeInsets.all(16),
//                 children: [
//                   Text('Chat with ${message['receiverId']}'),
//                   // Additional message details here...
//                 ],
//               );
//             }),
//           ),
//           Container(
//             padding: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.1),
//                   spreadRadius: 1,
//                   blurRadius: 3,
//                   offset: const Offset(0, -1),
//                 ),
//               ],
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: replyController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your reply...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 20,
//                         vertical: 10,
//                       ),
//                     ),
//                     maxLines: null,
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     if (replyController.text.trim().isNotEmpty) {
//                       controller.sendMessage(
//                         message['senderId'],
//                         message['receiverId'],
//                         replyController.text,
//                       );
//                       replyController.clear();
//                     }
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('Delete Message'),
//         content: const Text('Are you sure you want to delete this message?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.of(ctx).pop(),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(ctx).pop();
//               Get.back(); // Go back to the previous screen after deletion
//             },
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _forwardMessage(BuildContext context, Message message) {
//     // Implement forward functionality
//     Get.snackbar(
//       'Forward',
//       'Message forwarded successfully!',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }

//   void _blockSender(BuildContext context) {
//     // Implement block functionality
//     Get.snackbar(
//       'Block Sender',
//       '',
//       snackPosition: SnackPosition.BOTTOM,
//     );
//   }
// }

// class MessageBubble extends StatelessWidget {
//   final String message;
//   final String time;
//   final bool isFromMe;
//   final String senderName;
//   final String avatarUrl;

//   const MessageBubble({
//     Key? key,
//     required this.message,
//     required this.time,
//     required this.isFromMe,
//     required this.senderName,
//     required this.avatarUrl,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment:
//             isFromMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (!isFromMe) ...[
//             CircleAvatar(
//               backgroundImage: NetworkImage(avatarUrl),
//               radius: 16,
//             ),
//             const SizedBox(width: 8),
//           ],
//           Flexible(
//             child: Column(
//               crossAxisAlignment:
//                   isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//               children: [
//                 if (!isFromMe)
//                   Padding(
//                     padding: const EdgeInsets.only(left: 4, bottom: 4),
//                     child: Text(
//                       senderName,
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isFromMe ? Colors.blue : Colors.grey[200],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         message,
//                         style: TextStyle(
//                           color: isFromMe ? Colors.white : Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         time,
//                         style: TextStyle(
//                           fontSize: 11,
//                           color: isFromMe ? Colors.white70 : Colors.grey[600],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (isFromMe) const SizedBox(width: 24),
//         ],
//       ),
//     );
//   }
// }