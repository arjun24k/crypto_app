import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crypto_app/Utils/Currency.dart';
import 'package:crypto_app/Utils/fetchCrypto.dart';
import 'package:flutter/cupertino.dart';

class ChatBodyNotifier extends ChangeNotifier {
  ChatBodyNotifier();
  String initialQn = 'Do you want to add a new currency?';
  String exitMsg = 'Thank you...See you again!';
  String askCrypto = 'Please enter your prefered Crypto currency\n (eg. BTC)';
  String askFiat = 'Please enter your preferred Fiat currency \n(eg. USD)';
  String invalidResponse = 'Sorry, we dont know what you are saying';
  String invalidEntry = "Sorry, please enter valid data";
  String currency = '';
  String cryptoCurrency = '';
  String message = '';
  final currencyRef = FirebaseFirestore.instance.collection('currency');
  set setMsg(String mesg) {
    this.message = mesg;
    notifyListeners();
  }

  String setResultMsg(Currency c) {
    setDbData(c);
    return '1 ${c.cryptoChoice} = ${c.cryptoValue} ${c.fiatChoice}';
  }

  void setDbData(Currency c) {
    currencyRef.add(c.toMap());
    /* String key = "${c.cryptoChoice} ${c.fiatChoice}";
    String value = c.cryptoValue;
    prefs.setString(key, value); */
  }

  List<Message> messages = [
    Message('Hello there!..welcome to Crypto!', false),
    Message('Do you want to add a new currency?', false)
  ];

  Future<void> startConvo(String msg, bool sender, var scroll) async {
    String previousMsg =
        messages.lastWhere((element) => element.sender == false).msg;
    setMsg = '';
    messages.add(Message(msg, sender));
    notifyListeners();
    await scroll();
    if (previousMsg == initialQn) {
      switch (msg.toLowerCase()) {
        case 'no':
          {
            messages.add(Message(exitMsg, false));
            notifyListeners();
            await scroll();
          }
          break;
        case 'yes':
          {
            messages.add(Message(askCrypto, false));
            notifyListeners();
            await scroll();
          }
          break;
        default:
          {
            messages.add(Message(invalidResponse, false));
            messages.add(Message(initialQn, false));
            notifyListeners();
            await scroll();
          }
      }
    }
    if (previousMsg == askCrypto) {
      cryptoCurrency = msg;
      await scroll();
      messages.add(Message(askFiat, false));
      notifyListeners();
      await scroll();
    }
    if (previousMsg == askFiat) {
      currency = msg;
      bool isScrollError = false;
      String cryptoChoice = cryptoCurrency.toUpperCase().trim();
      String fiatChoice = currency.toUpperCase().trim();
      messages.add(Message('Please wait..', false));
      notifyListeners();
      await scroll();

      if (!await checkIfExists(cryptoChoice, fiatChoice)) {
        getCryptoData(cryptoChoice, fiatChoice).then((value) async {
          messages.removeLast();
          notifyListeners();
          if (value.errorCode < 400) {
            messages.add(Message(setResultMsg(value), false));
            notifyListeners();
            messages.add(Message(
                'You can view the above data in the Tracker Page', false));
            messages.add(Message(initialQn, false));
            notifyListeners();
          } else {
            messages.add(Message(value.ascertainError(), false));
            messages.add(Message(initialQn, false));
            notifyListeners();
          }
          try {
            await scroll(50.0);
          } catch (e) {
            print(e);
            isScrollError = true;
          }
        }).catchError((onError) async {
          print(onError);
          if (!isScrollError) {
            messages.removeLast();
            notifyListeners();
            messages.add(Message('An error has occurred', false));
            messages.add(Message(initialQn, false));
            notifyListeners();
            try {
              await scroll(50.0);
            } catch (e) {
              print(e);
              isScrollError = true;
            }
          }
        });
      } else {
        messages.add(Message('Entry already exists!', false));
        messages.add(Message(initialQn, false));
        notifyListeners();
        try {
          await scroll(50.0);
        } catch (e) {
          print(e);
          isScrollError = true;
        }
      }
    }
  }

  Future<bool> checkIfExists(String cryptoChoice, String fiatChoice) async {
    bool isPresent = false;
    await FirebaseFirestore.instance.collection('currency').get().then((value) {
      value.docs.forEach((element) {
        if (element.data()['cryptoChoice'] == cryptoChoice &&
            element.data()['fiatChoice'] == fiatChoice) isPresent = true;
      });
    }).catchError((onError) {
      isPresent = false;
    });
    return isPresent;
  }

  void updateCryptoData(Duration d) {}
}

class Message {
  final String msg;
  final bool sender;
  Message(this.msg, this.sender);
}
