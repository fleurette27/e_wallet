import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("A propos de SeedPay"),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text("This app was developed by Fleurette.",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
