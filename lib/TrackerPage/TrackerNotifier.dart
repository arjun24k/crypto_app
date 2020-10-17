import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/Utils/Currency.dart';
import 'package:crypto_app/Utils/fetchCrypto.dart';
import 'package:flutter/cupertino.dart';

class TrackerNotifier extends ChangeNotifier {
  Set<Currency> currencyList = Set<Currency>();
  bool isError = false;
  QuerySnapshot currencySnapshot;
  Timer updateTimer;
  final CollectionReference currencyRef =
      FirebaseFirestore.instance.collection('currency');
  Stream<DocumentSnapshot> currencyStream() =>
      currencyRef.doc('refreshRate').snapshots();
  StreamSubscription<DocumentSnapshot> currencySubscription;
  set setIsError(value) {
    this.isError = value;
    notifyListeners();
  }

  set setCurrencySnapshot(value) {
    this.currencySnapshot = value;
    notifyListeners();
  }

  Stream<DocumentSnapshot> fireStoreStream(String id) =>
      currencyRef.doc(id).snapshots();

  void initStream() {
    currencyRef.get().then((value) {
      value.docs.forEach(
        (element) {
          if (element.id != 'refreshRate') {
            currencyList.add(
              Currency(
                  element.data()['cryptoChoice'],
                  element.data()['cryptoValue'],
                  element.data()['fiatChoice'],
                  element.id),
            );
          }
        },
      );
      setCurrencySnapshot = value;
    }).catchError((onError) {
      print(onError);
      setIsError = true;
    });
    invokeCryptoStream();
  }

  void invokeCryptoStream() {
    currencySubscription = currencyStream().listen((event) {
      print(event.data());
      int sec = event.data()['sec'];
      updateCryptoValues(Duration(seconds: sec));
    });
  }

  void iterateCollection(QuerySnapshot value) {
    value.docs.forEach(
      (element) {
        updateCurrencyDoc(element);
      },
    );
  }

  void updateCurrencyDoc(QueryDocumentSnapshot element) {
    if (element.id != 'refreshRate') {
      String cryptoChoice = element.data()['cryptoChoice'].trim();
      String fiatChoice = element.data()['fiatChoice'].trim();
      getCryptoData(cryptoChoice, fiatChoice).then(
        (currency) {
          currency.updateData(element.id);
        },
      );
    }
  }

  void updateCryptoValues(Duration d) {
    if (updateTimer != null) updateTimer.cancel();
    updateTimer = new Timer.periodic(d, (Timer t) {
      try {
        currencyRef.get().then(
          (value) {
            if (value.docs.length > 1) {
              print('1');
              iterateCollection(value);
            }
          },
        );
      } catch (e) {
        print(e);
      }
    });
  }
}
