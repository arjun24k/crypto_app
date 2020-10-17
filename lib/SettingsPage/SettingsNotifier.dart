import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Settings.dart';

class SettingsNotifier extends ChangeNotifier {
  bool isLoading = false;
  final timeRef =
      FirebaseFirestore.instance.collection('currency').doc('refreshRate');
  int seconds = 0;
  set setIsLoading(value) {
    this.isLoading = value;
    notifyListeners();
  }

  set setSeconds(value) {
    this.seconds = value;
    notifyListeners();
  }

  Future submitData(Time t, BuildContext context) {
    setIsLoading = true;
    return timeRef.update(t.toMap()).then((value) async {
      setIsLoading = false;
      await showDoneDialog(context, 'Done');
    }).catchError((onError) async {
      setIsLoading = false;
      await showDoneDialog(context, 'An error has occured');
    });
  }

  Future showDoneDialog(BuildContext context, String text) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.grey[300],
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      text,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Text('Ok',
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.white)))
                  ],
                ),
              ),
            ));
      },
    );
  }
}
