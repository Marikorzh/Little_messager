import 'package:flutter/material.dart';
import 'package:messager/services/picture_fuction/picture_fuction.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const MyTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.obscureText,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color colorFB = Colors.deepPurple;
    Color colorEB = Colors.grey;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorEB)
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorFB),
        ),
        fillColor: Colors.black12,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey)
      ),
    );
  }
}
