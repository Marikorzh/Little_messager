import 'package:flutter/material.dart';
import 'package:messager/components/button_comp.dart';
import 'package:messager/components/text_field_comp.dart';
import 'package:messager/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text controllers
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPw = TextEditingController();

  //colors
  Color colorIcon = Colors.deepPurple;

  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signInWithEmailAndPassword(
          controllerEmail.text,
          controllerPw.text,
      );
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
                  Icons.message,
                  size: 150,
                  color: colorIcon,),

                SizedBox(height: 50,),

                //welcome back! text
                Text("Welcome back! You been missed!",style: TextStyle(fontSize: 16),),

                SizedBox(height: 25,),

                //email field
                MyTextField(
                    controller: controllerEmail,
                    hintText: "email",
                    obscureText: false),

                SizedBox(height: 10,),

                //password
                MyTextField(
                    controller: controllerPw,
                    hintText: "password",
                    obscureText: true),

                SizedBox(height: 25,),

                //sign in button
                MyButton(onTap: signIn, text: "Sign In",),

                SizedBox(height: 25,),

                //not remember!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // not member, text
                    Text("Not a member?"),

                    const SizedBox(width: 4,),

                    //register, text
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text("Register now!",
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
