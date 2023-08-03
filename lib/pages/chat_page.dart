import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messager/components/text_field_comp.dart';
import 'package:messager/services/chat/%D1%81hat_service.dart';
import 'package:messager/services/picture_fuction/picture_fuction.dart';

import '../components/chat_bubble.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverToken;
  const ChatPage(
      {Key? key,
      required this.receiverUserEmail,
      required this.receiverUserID,
      required this.receiverToken})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Timestamp time = new Timestamp(0, 0);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void setStat(String status) async {
    await _firebaseFirestore
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .update({
      "status": status,
      "time": DateFormat('dd.MM.y HH:mm').format(DateTime.now()).toString()
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    state == AppLifecycleState.resumed ? setStat("online") : setStat("offline");
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);
      //clear controller after
      _chatService.sendPushMessage(
          _messageController.text, widget.receiverToken);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(children: [
          Text(
            widget.receiverUserEmail,
          ),
          StreamBuilder(
            stream: _firebaseFirestore
                .collection('users')
                .doc(widget.receiverUserID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Waiting...");
              }

              return Text(
                  snapshot.data!["status"] == "online"
                      ? "online"
                      : "offline ${snapshot.data!["time"]}",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                      color: snapshot.data!["status"] == "online"
                          ? Colors.deepPurple.shade300
                          : Colors.grey.shade500));
            },
          )
        ]),
      ),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _auth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error ${snapshot.error}");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Waiting...");
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;

    //align the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data["senderId"] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Timestamp timestamp = data["timestamp"];
    var dt =
        DateTime.fromMillisecondsSinceEpoch(timestamp.millisecondsSinceEpoch);
    var dt2 = DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch);

    var date = DateFormat('dd.MM.y').format(dt).toString();
    var date2 = DateFormat('dd.MM.y').format(dt2).toString();

    int pere = date.compareTo(date2);
    if (pere > 0) {
      time = data["timestamp"];
    }

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data["senderId"] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data["senderId"] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            pere > 0 ? DataSorted(date) : Container(),
            Text(data["senderEmail"]),
            SizedBox(
              height: 8,
            ),
            data["type"] != "img"
                ? ChatBubble(
                    msg: data["message"],
                    additionalInfo: data["timestamp"],
                    color: (data["senderId"] == _auth.currentUser!.uid)
                        ? Colors.deepPurple
                        : Colors.black12,
                    type: "text",
                  )
                : ChatBubble(
                msg: data["message"],
                additionalInfo: data["timestamp"],
                color: (data["senderId"] == _auth.currentUser!.uid)
                ? Colors.deepPurple
                : Colors.black12,
                type: "img")
          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
      child: Row(
        children: [
          //textfield
          Expanded(
            child: PictureFunction(
              receiverId: widget.receiverUserID,
              controller: _messageController,
            ),
          ),

          //send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget DataSorted(String date) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade600,
        ),
        child: Text(date),
      ),
    );
  }
}
