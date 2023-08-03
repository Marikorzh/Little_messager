import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String token;
  final String type;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp,
    required this.message,
    required this.token,
    required this.type,
  });

  //convert to map
  Map<String, dynamic> toMap(){
    return {
      "senderId" : senderId,
      "senderEmail" : senderEmail,
      "receiverId" : receiverId,
      "timestamp" : timestamp,
      "message" : message,
      "token" : token,
      "type" : type,
    };
  }
}