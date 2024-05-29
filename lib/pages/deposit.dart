import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
// import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/webview_feda.dart';
import 'package:mobile_payement_app/services/account_service.dart';
class Deposit extends StatefulWidget {
  const Deposit({super.key});

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? depositUrl;
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

   Future<void> _handleDeposit() async {
    if (_formKey.currentState!.validate()) {
      double amount = double.parse(_amountController.text);
      String url = await makeFedaDeposit(amount);

      setState(() {
        url = url;
      });
        Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) => WebviewFeda(
                  url: url,
                )),
      );
    }
  }

//   Future<void> _handleDeposit() async {
//     if (_formKey.currentState!.validate()) {
//       double amount = double.parse(_amountController.text);
//       ApiResponse response = await makeDeposit(amount);

//       if (response.error == null) {
//         // Réinitialisation du champ de saisie
//         setState(() {
//           _amountController.text = "";
//         });

//         // Affichage d'un message de succès
//         String successMessage = response.data is String
//             ? response.data as String
//             : 'Dépôt effectué avec succès';
//         Get.snackbar('Succès', successMessage,
//             backgroundColor: Colors.green, colorText: Colors.white);

//  // Redirection vers la page précédente
//        Get.off(const HomeScreen()); // Remplacez HomeScreen() par votre page d'accueil      } else {
//         // Affichage d'un message d'erreur
//         String errorMessage = response.error is String
//             ? response.error as String
//             : 'Une erreur est survenue';
//         Get.snackbar('Erreur', errorMessage,
//             backgroundColor: Colors.green, colorText: Colors.white);
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back_ios_new),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                      // } else if (double.parse(value) > 10000) {
                      //   return 'Veuillez entrer une valeur inférieure à 10000';
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
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _handleDeposit,
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor:
                            Colors.green, // Couleur d'arrière-plan verte
                      ),
                      child: const Text(
                        "Déposer",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Couleur du texte blanc
                        ),
                      ),
                    )),
                  //  if (depositUrl != null)
                  // Expanded(
                  //   child: WebView(
                  //     initialUrl: depositUrl!,
                  //     javascriptMode: JavascriptMode.unrestricted,
                  //   ),
                  // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
