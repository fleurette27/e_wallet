import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/services/account_service.dart';


//la liste de toute les transactions effectué par l'utulisateur
Future<dynamic> getTransactions() async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse(transactionURL),
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    List<dynamic> transactionJsonList =
        json.decode(response.body)['transactions'];
    return transactionJsonList;
  } else {
    throw Exception('Échec de téléchargement des transactions');
  }
}


//les 5 dernièeres transactions effectuées par l'user
 
Future<dynamic> getRecenteTransactions() async {
  String token = await getToken();
  final response = await http.get(
    Uri.parse(recenteTransactionURL),
    headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    List<dynamic> transactionJsonList =
        json.decode(response.body)['transactions'];
    return transactionJsonList;
  } else {
    throw Exception('Échec de téléchargement des transactions');
  }


//transaction avec fedapay mais elle a été annulé, on utulise plus cet agregrateur

 // Future<Map<String, dynamic>> createTransaction(double amount) async {
//   try {
//     String token = await getToken();

//     final response = await http.post(
//       Uri.parse(fedaTransferURL),
//       headers: {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: {
//         'amount': amount.toString(),
//       },
//     );

//     if (response.statusCode == 200) {
//       // Conversion de la réponse JSON en Map<String, dynamic>
//       final Map<String, dynamic> responseData = json.decode(response.body);

//       // Récupération du token et de l'URL depuis la réponse
//       final Map<String, dynamic> tokenInfo = responseData['token'];
//       final String token = tokenInfo['token'];
//       final String url = tokenInfo['url'];

//       // Retour du token et de l'URL sous forme de Map
//       return {'token': token, 'url': url};
//     } else {
//       // Gérer les cas d'erreur
//       throw Exception(
//           'Erreur lors de la création de la transaction : ${response.statusCode}');
//     }
//   } catch (e) {
//     // Gérer les exceptions
//     throw Exception('Erreur lors de la création de la transaction : $e');
//   }
// }

}
