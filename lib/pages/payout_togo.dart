// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'dart:convert';

import 'package:mobile_payement_app/services/account_service.dart';

class PayoutTogoFeexpay extends StatefulWidget {
  const PayoutTogoFeexpay({super.key});

  @override
  State<PayoutTogoFeexpay> createState() => _PayoutTogoFeexpayState();
}

class _PayoutTogoFeexpayState extends State<PayoutTogoFeexpay> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController motifController = TextEditingController();
  String phoneNumber = '';
  String selectedNetwork = 'TOGOCOM TG';
  final String apiUrl = 'https://api.feexpay.me/api/payouts/public/togo';
  final String apiKey =
      'fp_he0e0lL6Q5VyAu7znX1j3aXgkgVs3UtZVOZSCEG7VSP8pgjFWajZtd4oRb6XjFw9';
  final String shopId = '6658f684de449872c1dfe91b';

  Future<void> sendPayoutRequest() async {
    if (!_formKey.currentState!.validate()) return;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'phoneNumber': phoneNumber,
        'amount': double.parse(amountController.text),
        'shop': shopId, // Utilisation de la valeur fixe pour shop
        'network': selectedNetwork,
        'motif': motifController.text,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final status = responseData['status'];

      String message;
      if (status == 'SUCCESSFUL') {
        makeWithdrawal(amountController.text as double);

        message = 'Reussite de la Transaction : ${responseData['reference']}';
      } else {
        message = 'Echec de la Transaction : ${responseData['reference']}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction Failed: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
          ),
        ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: IntlPhoneField(
                      controller: phoneNumberController,
                      initialCountryCode: "BJ",
                      onChanged: (value) {
                        setState(() {
                          phoneNumber = value.completeNumber;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Numéro de téléphone',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelStyle: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(labelText: 'Montant'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un montant';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedNetwork,
                    items: <String>['TOGOCOM TG', 'MOOV TG']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedNetwork = newValue!;
                      });
                    },
                    decoration: const InputDecoration(labelText: 'Réseau'),
                  ),
                  TextFormField(
                    controller: motifController,
                    decoration: const InputDecoration(labelText: 'Motif'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un motif';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: sendPayoutRequest,
                    child: const Text('Retrait'),
                  ),
                ],
              ),
            ),
          ),
       
        ],
      ),
    );
  }
}
