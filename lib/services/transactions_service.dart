import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/services/account_service.dart';

Future<dynamic> getTransactions() async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse(transactionURL),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['transactions'];
  } else {
    throw Exception('Échec de téléchargement des transactions');
  }
}

Future<dynamic> getRecenteTransactions() async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse(recenteTransactionURL),
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    },
  );

  if (response.statusCode == 200) {
    return json.decode(response.body)['recenteTransactions'];
  } else {
    throw Exception('Échec de téléchargement des transactions');
  }
}
