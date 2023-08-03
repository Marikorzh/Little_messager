import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {

  final String msg;
  final Timestamp additionalInfo;
  final Color color;
  final String type;

  ChatBubble({
    required this.msg,
    required this.additionalInfo,
    required this.color,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {

    var dt = DateTime.fromMillisecondsSinceEpoch(additionalInfo.millisecondsSinceEpoch);
    var d24 = DateFormat('HH:mm').format(dt);

    return Card(
      color: color,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: type == "text" ? RichText(
              text: TextSpan(
                children: <TextSpan>[

                  //real message
                  TextSpan(
                    text: msg + "          ",
                    //style: Theme.of(context).textTheme.subtitle1,
                  ),

                  //fake additionalInfo as placeholder
                  TextSpan(
                    text: "",
                  ),
                ],
              ),
            ) : Image.network(msg),
          ),

          //real additionalInfo
          Positioned(
            child: Text(
              d24.toString(),
              style: TextStyle(
                fontSize: 10.0,
              ),
            ),
            right: 8.0,
            bottom: 4.0,
          )
        ],
      ),
    );
  }
}
