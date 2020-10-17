import 'package:flutter/material.dart';

class MsgBubble extends StatelessWidget {
  final String msg;
  final bool sender;
  const MsgBubble(this.msg, this.sender);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: sender ? EdgeInsets.only(right: 10) : EdgeInsets.only(left: 10),
      margin: EdgeInsets.symmetric(vertical: 8),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        child: Text(
          msg,
          style: TextStyle(color: Colors.white),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: !sender ? Radius.zero : Radius.circular(15),
              bottomRight: sender ? Radius.zero : Radius.circular(15)),
          gradient: LinearGradient(
            colors: sender
                ? [Colors.blue, Colors.lightBlue]
                : [Colors.blue, Colors.lightBlue],
          ),
        ),
      ),
    );
  }
}
