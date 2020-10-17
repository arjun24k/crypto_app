import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:crypto_app/Utils/Currency.dart';
import 'dart:convert';

Future<Currency> getCryptoData(String cryptoChoice, String fiatChoice) async {
  var url = 'https://rest.coinapi.io/v1/exchangerate/$cryptoChoice/$fiatChoice';
  Map<String, String> headers = {'X-CoinAPI-Key': '<YOUR API KEY>'};
  http.Response response = await http.get(url, headers: headers);
  var parsedJson = jsonDecode(response.body);
  print(parsedJson);
  //String cryptoChoiceRes = parsedJson['asset_id_base'];
  String cryptoValueRes = parsedJson['rate'].toString();
  //String fiatChoiceRes = parsedJson['asset_id_quote'];
  Currency c = Currency(cryptoChoice, cryptoValueRes, fiatChoice);
  print(response.statusCode);
  if (response.statusCode > 400) {
    c.setError = response.statusCode;
  }
  return c;
}
