import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../model/message.dart';

class ChatService extends ChangeNotifier{
  // instance of auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final navigatorKey = GlobalKey<NavigatorState>();
  late String token;

  //send messages
  Future<void> sendMessage(String receiverId, String message) async {
    await _firebaseMessaging.requestPermission();
    //get current user info
    final String currentId = _auth.currentUser!.uid;
    final String currentEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    final FCMToken = await _firebaseMessaging.getToken();

    //create new message
    Message newMessage = Message(
        senderId: currentId,
        senderEmail: currentEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message,
        token: FCMToken.toString(),
        type: "text"
    );

    //construct chat room id from current user id and receiver
    List<String> ids = [currentId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_"); // combine the ids into string, chatRoomId


    //add new message to database
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());

  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId){
    // construct chat room
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Future<void> handleBackgroundMessage(RemoteMessage remoteMessage) async{
    print("Title: ${remoteMessage.notification?.title}");
    print("Body: ${remoteMessage.notification?.body}");
    print("Payload: ${remoteMessage.data}");
  }

  Future<void> handleMessage(RemoteMessage? remoteMessage) async{
    if(remoteMessage == null) return;

    navigatorKey.currentState?.pushNamed(
      "lib/pages/chat_page.dart",
      arguments: remoteMessage,
    );
  }

  Future<void> initPushNotification() async{
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    final FCMToken = await _firebaseMessaging.getToken();
    print(FCMToken);

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  void sendPushMessage(String message, String token) async {
    try {
      await http.post(
          Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            "Content-Type": 'application/json',
            "Authorization": "key=AAAANOFG4jo:APA91bER6BKWKr9CPqA6rDaHZvLKa0XcvSSpT0xtMdrbQxeeLjqAgdeimQU4M1F8lD6DDnhb7Eci42Ro2rIxwJ7UXQi1g0RckPPsI0StQFTrhYfIpWFEJ9EV1HO5-Mh6HohdzVba_URO"
          },
          body: jsonEncode(
          <String, dynamic > {
        "notification": <String, dynamic>{
          "body": message,
          "title": "Повідомлення:"
        },
        "priority" : "high",
        "data" : <String, dynamic>{
          "click_action" : "FLUTTER_NOTIFICATION_CLICK",
          "id" : "1",
          "status" : "done",
        },
        "to" : token,
      }
      ));
      http.Response;
  }
  catch(e){
      print(e);
  }
  }
}