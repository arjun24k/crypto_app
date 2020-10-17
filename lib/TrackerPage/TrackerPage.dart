import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/TrackerPage/TrackerNotifier.dart';
import 'package:crypto_app/Utils/Currency.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackerPage extends StatefulWidget {
  final TrackerNotifier tracker;
  TrackerPage(this.tracker);

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<TrackerNotifier>(
      create: (context) => TrackerNotifier(),
      child: Consumer<TrackerNotifier>(
        builder: (context, value, child) => TrackerPage(value),
      ),
    );
  }

  @override
  _TrackerPageState createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  TrackerNotifier get tracker => widget.tracker;

  Widget _currencyCard(Currency c) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          margin: EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              textValue("Crypto Currrency: ${c.cryptoChoice}", Colors.black,
                  FontWeight.w300, 15),
              textValue("Fiat Currency: ${c.fiatChoice}", Colors.red,
                  FontWeight.w300, 15),
              StreamBuilder<DocumentSnapshot>(
                  stream: tracker.fireStoreStream(c.id.trim()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return textValue(
                          "1 ${snapshot.data.data()['cryptoChoice']} = ${snapshot.data.data()['cryptoValue']} ${snapshot.data.data()['fiatChoice']}",
                          Colors.black,
                          FontWeight.bold,
                          18);
                    } else if (snapshot.hasError) {
                      textValue("An error has occurred", Colors.black,
                          FontWeight.bold, 18);
                    }
                    return textValue(
                        "Loading...", Colors.black, FontWeight.bold, 18);
                  })
            ],
          )),
    );
  }

  Widget textValue(String text, var color, var fntWt, double fntSize) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: fntWt, color: color, fontSize: fntSize),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    tracker.updateTimer.cancel();
    tracker.currencySubscription.cancel();
  }

  @override
  void initState() {
    super.initState();
    tracker.initStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Tracker',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: tracker.currencySnapshot != null
          ? tracker.currencySnapshot.docs.length != 1
              ? ListView.builder(
                  itemCount: tracker.currencyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _currencyCard(tracker.currencyList.elementAt(index));
                  })
              : Center(
                  child: Text('You have not added any currencies yet!'),
                )
          : Center(
              child: tracker.isError
                  ? Text('An error has occurred!')
                  : CircularProgressIndicator(),
            ),
    );
  }
}
/* 
FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    prefs = snapshot.data;
                    currencyList = snapshot.data.getKeys().map((e) {
                      List<String> keyList = e.split(" ");
                      return Currency(keyList[0].trim(),
                          prefs.getString(e).trim(), keyList[1].trim(), '1');
                    }).toList();
                    if (currencyList.isEmpty)
                      return Center(child: Text('No items to show'));
                    else
                      return ListView.builder(
                          itemCount: currencyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return _currencyCard(currencyList[index]);
                          });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
 */
