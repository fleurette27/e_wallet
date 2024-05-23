import 'package:flutter/material.dart';
import 'package:mobile_payement_app/pages/sign_otp.dart';
import 'package:mobile_payement_app/theme/color.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/welcom.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Centered content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 350),
                // Titre
                Text(
                  "SeedPay",
                   textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade900,
                  ),
                ),
                // Sous-titre
                const SizedBox(height: 20),
                Text(
                  "SeedPay : la solution idéale pour vos transactions financières",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green.shade900,
                  ),
                ),
                // Espacement
                const SizedBox(height: 50),

                // Boutons
                Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        // Action lorsque le premier bouton est appuyé
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignWithOtp()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: secondary, // Fond transparent
                        side: const BorderSide(
                            color: secondary), // Bordure du bouton
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15), // Espacement interne
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)), // Forme du bouton
                      ),
                      child:  const Text(
                        "Commencer",
                        style: TextStyle(fontSize: 16,color: white,),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
