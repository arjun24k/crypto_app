import 'package:crypto_app/HomePage.dart';
import 'package:crypto_app/MainBody.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Alata'),
        debugShowCheckedModeBanner: false,
        home: HomePage() //MainBody(),
        );
  }
}
