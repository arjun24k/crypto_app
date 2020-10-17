import 'package:crypto_app/MainBody.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  Widget _textHeader(String text) {
    return Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),
    );
  }

  Widget _getStartedButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.06,
        child: OutlineButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          borderSide: BorderSide(color: Colors.white),
          onPressed: () {
            setState(() {
              isLoading = true;
            });
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (context) => MainBody(),
              ),
            )
                .then((value) {
              setState(() {
                isLoading = false;
              });
            }).catchError((e) {
              print(e);
              isLoading = false;
            });
          },
          child: Text(
            'GET STARTED',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.transparent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[600], Colors.lightBlue[900]],
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
          child: Column(
            children: [
              _textHeader('Welcome to'),
              _textHeader('Crypto'),
              !isLoading
                  ? _getStartedButton(context)
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      child: CircularProgressIndicator(),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
