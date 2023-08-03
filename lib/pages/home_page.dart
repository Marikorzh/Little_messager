import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messager/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  void signOut() async{
    //get auth service
    await _firebaseFirestore.collection("users").doc(_auth.currentUser!.uid).update({
      "status" : "offline"
    });
    final authService = Provider.of<AuthService>(context, listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          //sign out button
          IconButton(onPressed: signOut, icon: const Icon(Icons.logout))
        ],
      ),
      body: _buidUserList(),
    );
  }

  //build a list of users except for current logged in user
  Widget _buidUserList(){
    return StreamBuilder<QuerySnapshot>(stream: FirebaseFirestore.instance.collection("users").snapshots(),
    builder: (context, snapshot){
      if(snapshot.hasError){
        return const Text("Error");
      }
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Text("loading...");
      }
      return ListView(
        children: snapshot.data!.docs.map<Widget>((doc) => _buidUserListItem(doc)).toList(),
      );
    });
  }

  //build a item of list users
  Widget _buidUserListItem(DocumentSnapshot document){
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //displays all user except current user
    if(_auth.currentUser!.email != data["email"]){
      return ListTile(
        title: Text(data["email"]),
        onTap: (){
          //pass the clicked user's UID to the chat page
          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
            receiverUserEmail: data["email"],
            receiverUserID: data["uid"],
          receiverToken: data["token"],)
          ));
        },
      );
    }
    //return empty container
    else{
      return Container();
    }
  }

}
