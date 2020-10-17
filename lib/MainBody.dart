import 'package:crypto_app/Utils/popUpMenu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'ChatBody/chatBody.dart';

class MainBody extends StatelessWidget {
  Widget _buildBody(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Alata'),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: PopUpMenu(),
            title: Text(
              'App',
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: ChatBody.create(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('An error has occurred'));
          }
          if (snapshot.hasData) {
            return _buildBody(context);
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}
