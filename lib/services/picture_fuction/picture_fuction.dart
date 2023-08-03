import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../model/message.dart';

class PictureFunction extends StatelessWidget {
  final TextEditingController controller;
  final String receiverId;
   PictureFunction({Key? key, required this.controller, required this.receiverId}) : super(key: key);

  @override
  Widget build(BuildContext context) {

      Color colorFB = Colors.deepPurple;
      Color colorEB = Colors.grey;

      return TextField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: (){gallery();},
              icon: const Icon(Icons.image),
            ),
            suffixIconColor: Colors.deepPurple.shade400,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: colorEB)
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colorFB),
            ),
            fillColor: Colors.black12,
            filled: true,
            hintText: "Enter message...",
            hintStyle: const TextStyle(color: Colors.grey)
        ),
      );
  }

  File? imgFile;

  Future gallery() async{
    ImagePicker _picker = ImagePicker();
    await _picker.pickImage(source: ImageSource.gallery).then((xFile){
      if(xFile != null){
        imgFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async{
    String fileName = Uuid().v1();
    int status = 1;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

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
        message: fileName,
        token: FCMToken.toString(),
        type: "img");

    //construct chat room id from current user id and receiver
    List<String> ids = [currentId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_"); // combine the ids into string, chatRoomId


    //add new message to database
    await _firebaseFirestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .doc(fileName)
        .set(newMessage.toMap());

    var ref =
    FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");

    var uploadTask = await ref.putFile(imgFile!).catchError((e) async{

      await _firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .doc(fileName)
          .delete();

      status = 0;
    });

    if(status == 1){
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firebaseFirestore
          .collection("chat_rooms")
          .doc(chatRoomId)
          .collection("messages")
          .doc(fileName).update({
              "message" : imageUrl,
          });
    }

  }
}
