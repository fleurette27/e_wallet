// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:feexpay_flutter/feexpay_flutter.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:random_string/random_string.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String randomString = randomAlphaNumeric(15);
  String url = '';
  String? balance;
  Account? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as Account;
        balance = user!.balance != null ? user!.balance.toString() : '0';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
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
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Dépôt",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(" Total Balance",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color)),
                          Text('$balance',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color)),
                        ],
                      ),
                    ),
                    const Text("Montant du dépôt",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        labelText: 'Montant',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty || value.contains('-')) {
                          return 'Veuillez entrer un montant valide';
                        } else if (value.contains('.')) {
                          return 'Veuillez entrer un nombre sans décimale';
                        } else if (!value.isNumericOnly) {
                          return 'Veuillez entrer une valeur numérique';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            _amountController.text = "1000";
                          },
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          child: Text("1000",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            _amountController.text = "2000";
                          },
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          child: Text("2000",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            _amountController.text = "5000";
                          },
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          child: Text("5000",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                        TextButton(
                          onPressed: () {
                            _amountController.text = "10000";
                          },
                          style: TextButton.styleFrom(
                            shape: const StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.black
                                    : Colors.white,
                          ),
                          child: Text("10000",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.white
                                      : Colors.black)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    MaterialButton(
                      color: const Color(0xFF112C56),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChoicePage(
                              token:
                                  'fp_he0e0lL6Q5VyAu7znX1j3aXgkgVs3UtZVOZSCEG7VSP8pgjFWajZtd4oRb6XjFw9',
                              id: '6658f684de449872c1dfe91b',
                              amount: double.parse(_amountController.text),
                              redirecturl: '/home',
                              trans_key: randomString,
                              callback_info: '{"status"}',
                            ),
                          ),
                        );
                      },
                      child: const Text('Déposer'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        ],
      ),
    );
  }
}
