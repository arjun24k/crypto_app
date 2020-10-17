import 'package:cloud_firestore/cloud_firestore.dart';

class Currency {
  final String cryptoValue;
  final String cryptoChoice;
  final String fiatChoice;
  final String id;
  int errorCode = 0;
  Currency(this.cryptoChoice, this.cryptoValue, this.fiatChoice, [this.id]);
  set setError(value) {
    this.errorCode = value;
  }

  String ascertainError() {
    String error = '';
    switch (errorCode) {
      case 400:
      case 401:
      case 403:
      case 429:
        error = 'API error';
        break;
      default:
        error = 'Sorry, please enter valid data';
    }
    return error;
  }

  Map<String, dynamic> toMap() {
    return {
      'cryptoChoice': this.cryptoChoice,
      'fiatChoice': this.fiatChoice,
      'cryptoValue': this.cryptoValue
    };
  }

  Map<String, dynamic> cryptoValueMap() {
    return {
      'cryptoValue': this.cryptoValue != 'null' ? this.cryptoValue : 'API Error'
    };
  }

  bool notNull() {
    return cryptoChoice != null && fiatChoice != null;
  }

  void updateData(String id) {
    FirebaseFirestore.instance
        .collection('currency')
        .doc(id)
        .update(this.cryptoValueMap());
  }

  /*  @override
  String toString() {
    return "${this.cryptoChoice}_${this.fiatChoice}_${this.cryptoValue}".trim();
  } */
}
