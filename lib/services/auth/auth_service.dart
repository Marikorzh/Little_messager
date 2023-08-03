import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AuthService extends ChangeNotifier {
  // instance for auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  //instance for firestore
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  //sign user in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      var FCMToken = await _firebaseMessaging.getToken();
      //sign in
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      var date  = DateFormat('dd.MM.y HH:mm').format(DateTime.now()).toString();

      //add new document for the user in users collection if it not exists
      _firebaseFirestore.collection("users").doc(userCredential.user!.uid).set({
        "uid" : userCredential.user!.uid,
        "email" : email,
        "status" : "online",
        "time" : date,
        "token" : FCMToken.toString(),
      }, SetOptions(merge: true));

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //create new user
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      var FCMToken = await _firebaseMessaging.getToken();
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      var date  = DateFormat('dd.MM.y HH:mm').format(DateTime.now()).toString();

      //after create user, create new document for user
      _firebaseFirestore.collection("users").doc(userCredential.user!.uid).set({
        "uid" : userCredential.user!.uid,
        "email" : email,
        "status" : "online",
        "time" : date,
        "token" : FCMToken.toString(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}
