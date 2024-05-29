import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_payement_app/network_api/currency_service.dart';

class Convert extends StatefulWidget {
  const Convert({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ConvertState createState() => _ConvertState();
}

class _ConvertState extends State<Convert> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final API api = API();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Convertir",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownMenu(
                      enableFilter: false,
                      enableSearch: false,
                      controller: _fromController,
                      initialSelection: "USD",
                      menuHeight: 360,
                      label: const Text("From"),
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => Theme.of(context).canvasColor),
                        elevation:
                            WidgetStateProperty.resolveWith((states) => 10.0),
                        shape: WidgetStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "USD", label: "USD"),
                        DropdownMenuEntry(value: "EUR", label: "EUR"),
                        DropdownMenuEntry(value: "XOF", label: "XOF"),
                        DropdownMenuEntry(value: "GBP", label: "GBP"),
                        DropdownMenuEntry(value: "JPY", label: "JPY"),
                        DropdownMenuEntry(value: "AUD", label: "AUD"),
                        DropdownMenuEntry(value: "CAD", label: "CAD"),
                        DropdownMenuEntry(value: "CHF", label: "CHF"),
                        DropdownMenuEntry(value: "EGP", label: "EGP"),
                        DropdownMenuEntry(value: "CNY", label: "CNY"),
                        DropdownMenuEntry(value: "HKD", label: "HKD"),
                        DropdownMenuEntry(value: "NZD", label: "NZD"),
                        DropdownMenuEntry(value: "SEK", label: "SEK"),
                        DropdownMenuEntry(value: "SGD", label: "SGD"),
                        DropdownMenuEntry(value: "KRW", label: "KRW"),
                        DropdownMenuEntry(value: "MXN", label: "MXN"),
                        DropdownMenuEntry(value: "INR", label: "INR"),
                        DropdownMenuEntry(value: "RUB", label: "RUB"),
                        DropdownMenuEntry(value: "ZAR", label: "ZAR"),
                        DropdownMenuEntry(value: "TRY", label: "TRY"),
                        DropdownMenuEntry(value: "BRL", label: "BRL"),
                        DropdownMenuEntry(value: "TWD", label: "TWD"),
                        DropdownMenuEntry(value: "THB", label: "THB"),
                        DropdownMenuEntry(value: "MYR", label: "MYR"),
                        DropdownMenuEntry(value: "PHP", label: "PHP"),
                        DropdownMenuEntry(value: "IDR", label: "IDR"),
                      ]),
                  DropdownMenu(
                      enableFilter: false,
                      enableSearch: false,
                      controller: _toController,
                      initialSelection: "USD",
                      menuHeight: 360,
                      label: const Text("To"),
                      menuStyle: MenuStyle(
                        backgroundColor: WidgetStateColor.resolveWith(
                            (states) => Theme.of(context).canvasColor),
                        elevation:
                            WidgetStateProperty.resolveWith((states) => 10.0),
                        shape: WidgetStateProperty.resolveWith((states) =>
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
                      dropdownMenuEntries: const [
                        DropdownMenuEntry(value: "USD", label: "USD"),
                        DropdownMenuEntry(value: "EUR", label: "EUR"),
                        DropdownMenuEntry(value: "GBP", label: "GBP"),
                        DropdownMenuEntry(value: "XOF", label: "XOF"),
                        DropdownMenuEntry(value: "JPY", label: "JPY"),
                        DropdownMenuEntry(value: "AUD", label: "AUD"),
                        DropdownMenuEntry(value: "CAD", label: "CAD"),
                        DropdownMenuEntry(value: "CHF", label: "CHF"),
                        DropdownMenuEntry(value: "EGP", label: "EGP"),
                        DropdownMenuEntry(value: "CNY", label: "CNY"),
                        DropdownMenuEntry(value: "HKD", label: "HKD"),
                        DropdownMenuEntry(value: "NZD", label: "NZD"),
                        DropdownMenuEntry(value: "SEK", label: "SEK"),
                        DropdownMenuEntry(value: "SGD", label: "SGD"),
                        DropdownMenuEntry(value: "KRW", label: "KRW"),
                        DropdownMenuEntry(value: "MXN", label: "MXN"),
                        DropdownMenuEntry(value: "INR", label: "INR"),
                        DropdownMenuEntry(value: "RUB", label: "RUB"),
                        DropdownMenuEntry(value: "ZAR", label: "ZAR"),
                        DropdownMenuEntry(value: "TRY", label: "TRY"),
                        DropdownMenuEntry(value: "BRL", label: "BRL"),
                        DropdownMenuEntry(value: "TWD", label: "TWD"),
                        DropdownMenuEntry(value: "THB", label: "THB"),
                        DropdownMenuEntry(value: "MYR", label: "MYR"),
                        DropdownMenuEntry(value: "PHP", label: "PHP"),
                        DropdownMenuEntry(value: "IDR", label: "IDR"),
                      ]),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    labelText: 'Amount',
                  ),
                  style: const TextStyle(fontSize: 22),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    } else if (double.tryParse(value) == null) {
                      return 'Please enter a valid amount';
                    } else if (double.parse(value) <= 0) {
                      return 'Please enter a valid amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                enabled: false,
                style: const TextStyle(fontSize: 22),
                controller: _resultController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  disabledBorder: InputBorder.none,
                  labelText: 'Result',
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 50,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        double rate = await api.getRate(
                          _fromController.text,
                          _toController.text,
                          double.parse(_amountController.text),
                        );
                        double result =
                            rate * double.parse(_amountController.text);
                        setState(() {
                          _resultController.text = result.toStringAsFixed(2);
                        });
                      } catch (e) {
                        // Gérer les erreurs ici, par exemple afficher un message à l'utilisateur
                        Get.snackbar("Erreur", "Échec de la conversion");
                      }
                    }
                  },
                  // ignore: sort_child_properties_last
                  child: const Text(
                    "Convert",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
