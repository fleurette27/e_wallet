import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aide"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Si vous aviez besoin d'aide ,veuillez contactez notre service.",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text("Email:gfleurette27@gmail.com",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Phone:+229 90099070",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
