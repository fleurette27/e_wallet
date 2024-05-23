import 'dart:convert';

import 'package:http/http.dart' as http;



class API {
  Future<double> getRate (String from, String to, double amount) async {
  // L'URL de l'API
  final String apiUrl = 'https://api.apilayer.com/currency_data/convert?to=$to&from=$from&amount=$amount';

  // L'entête de la requête avec la clé API
      final response = await http.get(Uri.parse(apiUrl), headers: {
    'apikey': 'RAKPtLmIvmb1Hbpf8Ip59p1pibOqBrbU',

    });

     if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return data['result']*1.0;
    } else {
      throw Exception('Échec du chargement des données');
    }
  }
}

class Currency {
  final double result;

  Currency({required this.result});

  factory Currency.fromJson(String json) {
    return Currency(
        result: double.parse(jsonDecode(json)['result'].toString()));
  }
}