import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/ChatBody/chatBodyNotifier.dart';
import 'package:crypto_app/Utils/msgBubble.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ChatBody extends StatefulWidget {
  final ChatBodyNotifier chatBody;

  const ChatBody(this.chatBody);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<ChatBodyNotifier>(
      create: (context) => ChatBodyNotifier(),
      child: Consumer<ChatBodyNotifier>(
          builder: (context, chatBody, _) => ChatBody(chatBody)),
    );
  }

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  final TextEditingController _messageController = new TextEditingController();
  final ScrollController _scrollController = new ScrollController();
  dynamic app;
  ChatBodyNotifier get chatBody => widget.chatBody;

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    _scrollController.dispose();
  }

  Widget _chatArea() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.lightBlue[100],
      child: Container(
        margin:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.095),
        color: Colors.lightBlue[100],
        child: ListView.builder(
            controller: _scrollController,
            itemCount: chatBody.messages.length,
            itemBuilder: (BuildContext context, int index) {
              return MsgBubble(chatBody.messages[index].msg,
                  chatBody.messages[index].sender);
            }),
      ),
    );
  }

  Widget _textFieldBackground() {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottom -
          MediaQuery.of(context).size.height * 0.04,
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width,
      child: Container(
        color: Colors.blue[200],
      ),
    );
  }

  Widget _msgField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        controller: _messageController,
        onChanged: (value) {
          chatBody.message = value;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: new BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  Widget _sendButton(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: ShapeDecoration(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: IconButton(
          icon: Icon(Icons.send),
          onPressed: () async {
            await chatBody.startConvo(chatBody.message, true, scrollToBottom);
            _messageController.clear();
          }),
    );
  }

  Future<void> scrollToBottom([double value = 0]) async {
    await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100 + value,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut);
  }

  /* setRefreshRate() {
    try {
      int min = chatBody.prefs.getInt('refreshRateMin');
      int sec = chatBody.prefs.getInt('refreshRateMin');
      chatBody.updateCryptoData(Duration(seconds: sec, minutes: min));
    } catch (e) {}
  } */

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        _chatArea(),
        _textFieldBackground(),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_msgField(), _sendButton(context)],
          ),
        ),
      ],
    );
  }
}

/* 
Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        
      ],
    );
 */
