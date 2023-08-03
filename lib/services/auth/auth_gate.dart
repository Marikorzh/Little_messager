import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

import "../../pages/home_page.dart";
import "login_or_register.dart";

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          //user is logger in
          if(snapshot.hasData){
            return HomePage();
          }
          //user is NOT logger in
          else{
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
