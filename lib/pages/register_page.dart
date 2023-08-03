import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/button_comp.dart';
import '../components/text_field_comp.dart';
import '../services/auth/auth_service.dart';


class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text controllers
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPw = TextEditingController();
  TextEditingController controllerConfPw = TextEditingController();

  // colors
  Color colorIcon = Colors.deepPurple;

  //function for sing up
  void signUp() async{
    if(controllerPw.text != controllerConfPw.text){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Password to not match!")));
      return;
    }

    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signUpWithEmailAndPassword(
          controllerEmail.text,
          controllerPw.text);
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50,),

                //logo
                Icon(
                  Icons.icecream,
                  size: 150,
                  color: colorIcon,),

                SizedBox(height: 50,),

                //create account, text
                Text("Create account here! Let\'s go! ",style: TextStyle(fontSize: 20),),

                SizedBox(height: 25,),

                //email field
                MyTextField(
                    controller: controllerEmail,
                    hintText: "Email",
                    obscureText: false),

                SizedBox(height: 10,),

                //password
                MyTextField(
                    controller: controllerPw,
                    hintText: "Password",
                    obscureText: true),

                SizedBox(height: 10,),

                //confirm password
                MyTextField(
                    controller: controllerConfPw,
                    hintText: "Confirm password",
                    obscureText: true),

                SizedBox(height: 25,),

                //sign Up, button
                MyButton(onTap: signUp, text: "Sign Up",),

                SizedBox(height: 25,),

                //not remember!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //already, text
                    Text("Already a member?"),

                    SizedBox(width: 4,),

                    //login, text
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text("Login now!",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
