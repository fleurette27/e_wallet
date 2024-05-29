import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/services/account_service.dart';

class Transfer extends StatefulWidget {
  const Transfer({super.key});

  @override
  State<Transfer> createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  Future<void> _handleTransfer() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      String email = _emailController.text;

      ApiResponse response = await transferMoney(amount, email);

      if (response.error == null) {
        // Réinitialisation des champs de saisie
        setState(() {
          _amountController.text = "";
          _emailController.text = "";
        });

        // Affichage d'un message de succès
        String successMessage = response.data is String ? response.data as String : 'Transfert effectué avec succès';
        Get.snackbar('Succès', successMessage,
            backgroundColor: Colors.green, colorText: Colors.white);

        // Retour à la page précédente
       Get.off(const HomeScreen()); // Remplacez HomeScreen() par votre page d'accueil      } else {
      } else {
        // Affichage d'un message d'erreur
        String errorMessage = response.error is String ? response.error as String : 'Une erreur est survenue';
        Get.snackbar('Erreur', errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),),
        body: SingleChildScrollView(
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
                  child: Text("Transfert",
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
                      Text("$balance",
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
              const Text("Montant à transférer",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  } else if (double.parse(value) > 10000) {
                    return 'Veuillez entrer une valeur inférieure à 10000';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
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
                                    : Colors.black))),
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
                                    : Colors.black))),
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
                                    : Colors.black))),
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
                                    : Colors.black))),
                  ]),
              const SizedBox(height: 20),
              const Text("Email du destinataire",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Veuillez entrer un email valide';
                  } else if (!value.isEmail) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _handleTransfer,
                  style: ElevatedButton.styleFrom( shape: const StadiumBorder(),
                        backgroundColor:
                            Colors.green, // Couleur d'arrière-plan verte
                      ),
                  child: const Text("Transférer",
                      style: TextStyle(
                        fontSize: 18,
                        color:Colors.white,
                      )),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/transactions');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                        backgroundColor:
                            Colors.green, // Couleur d'arrière-plan verte
                      ),
                  child: const Text("Historique des transactions",
                      style: TextStyle(
                        fontSize: 18,
                        color:Colors.white,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
