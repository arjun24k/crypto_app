import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/SettingsPage/SettingsNotifier.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  final SettingsNotifier settings;
  final List<int> secondsList;
  Settings(this.settings, this.secondsList);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _textHeading(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    'Seconds:',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                secField(),
              ],
            ),
            !settings.isLoading
                ? submitButton(context)
                : Center(
                    child: CircularProgressIndicator(),
                  ),
            currentValue()
          ],
        ),
      ),
    );
  }

  Widget _textHeading() {
    return Text(
      'Settings',
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget secField() {
    return DropdownButton(
      value: settings.seconds,
      items: mapList(),
      onChanged: (value) {
        settings.setSeconds = value;
      },
    );
  }

  Widget currentValue() {
    return StreamBuilder<DocumentSnapshot>(
        stream: settings.timeRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String sec = snapshot.data.data()['sec'].toString();
            return Text(
              "Current value: $sec seconds",
              style: TextStyle(fontSize: 15),
            );
          }
          return Text(
            'Loading..',
            style: TextStyle(fontSize: 15),
          );
        });
  }

  List<DropdownMenuItem> mapList() {
    return secondsList
        .map(
          (secondValue) => DropdownMenuItem(
            child: Text(
              secondValue.toString(),
            ),
            value: secondValue,
          ),
        )
        .toList();
  }

  Widget submitButton(BuildContext context) {
    return FlatButton(
      onPressed: () async {
        await settings.submitData(Time(settings.seconds), context);
        await Future.delayed(
            Duration(milliseconds: 600), () => Navigator.of(context).pop());
      },
      child: Text(
        'Update refresh rate',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
      ),
      color: Colors.lightBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Time {
  final int sec;
  Time(this.sec);

  Map<String, dynamic> toMap() {
    return {'sec': this.sec};
  }
}

/*  Widget minField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          minutes = value;
        },
        decoration: InputDecoration(
          filled: true,
          hintStyle: TextStyle(fontSize: 12),
          hintText: 'Minutes',
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: new BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  } */
/* 
 int ascertainValue(String time) {
    int val = 0;
    try {
      val = int.parse(time.split(".")[0], onError: (value) => 0);
    } catch (e) {
      val = 0;
    }
    return val;
  }
  Widget secField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.2,
      child: TextField(
        keyboardType: TextInputType.number,
        onChanged: (value) {
          seconds = value;
        },
        decoration: InputDecoration(
          filled: true,
          hintStyle: TextStyle(fontSize: 12),
          hintText: 'Seconds',
          fillColor: Colors.white,
          border: new OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: new BorderSide(color: Colors.white)),
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  } */
