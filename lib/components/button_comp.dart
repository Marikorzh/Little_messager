import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onTap;
  final String text;
  const MyButton({Key? key, this.onTap, required this.text}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color colorButton = Colors.deepPurple;
    Color colorText = Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: colorButton,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Center(
          child: Text(text, style: TextStyle(
                color: colorText,
              fontWeight: FontWeight.bold,
              fontSize: 16),),
        ),
      ),
    );
  }
}
