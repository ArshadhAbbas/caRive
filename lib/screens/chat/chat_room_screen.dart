import 'package:carive/models/chat_model.dart';
import 'package:carive/services/auth.dart';
import 'package:carive/services/chat_service.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatRoomScreen extends StatefulWidget {
  ChatRoomScreen({
    Key? key,
    required this.userImage,
    required this.userName,
    required this.userId,
  });

  final String userImage;
  final String userName;
  final String userId;

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final chatService = ChatService();
  final auth = AuthService();
  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScaffold(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: themeColorGreen,
            leading: Wrap(
              direction: Axis.vertical,
              alignment: WrapAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back),
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.userImage),
                ),
              ],
            ),
            title: Text(widget.userName),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(auth.auth.currentUser!.uid)
                  .collection("chats")
                  .doc(widget.userId)
                  .collection("messages")
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                final messages = snapshot.data!.docs
                    .map((doc) => ChatMessage.fromSnapshot(doc))
                    .toList();

                // Group the messages by date
                final groupedMessages = groupBy(
                    messages,
                    (message) => DateFormat("dd MMM yyyy")
                        .format(message.time.toDate()));

                return Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      final date = groupedMessages.keys.elementAt(index);
                      final messagesForDate =
                          groupedMessages.values.elementAt(index);

                      // Build the date card
                      final dateCard = Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.grey[300],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            date,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              // color: Colors.white
                            ),
                          ),
                        ),
                      );

                      // Build the message bubbles for the current date
                      final messageBubbles = messagesForDate.reversed
                          .map((message) => _buildMessageBubble(
                                message.senderId,
                                message.textMessage,
                                message.time,
                              ))
                          .toList();

                      return Column(
                        children: [
                          dateCard,
                          ...messageBubbles,
                        ],
                      );
                    },
                  ),
                );
              },
            ),
          ),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Flexible(
                  child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: themeColorGrey,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: themeColorGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: themeColorGreen),
                      ),
                      hintText: "Type message here...",
                      hintStyle: TextStyle(color: themeColorblueGrey),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 25,
                  backgroundColor: themeColorGreen,
                  child: IconButton(
                    onPressed: () {
                      chatService.sendTextMessage(
                        auth.auth.currentUser!.uid,
                        widget.userId,
                        messageController.text.trim(),
                      );
                      messageController.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
    String senderId,
    String textMessage,
    Timestamp time,
  ) {
    final isCurrentUser = senderId == auth.auth.currentUser!.uid;
    final dateTime = DateFormat.jm().format(time.toDate());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Align(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isCurrentUser ? themeColorGrey : themeColorGreen,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                textMessage,
                style: TextStyle(
                  color: isCurrentUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                dateTime.toString(),
                style: TextStyle(
                  color: isCurrentUser
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
