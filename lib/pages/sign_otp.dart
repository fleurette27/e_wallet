import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mobile_payement_app/function/function_otp.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/verification_otp.dart';
import 'package:mobile_payement_app/theme/color.dart';

class SignWithOtp extends StatefulWidget {
  const SignWithOtp({super.key});

  @override
  State<SignWithOtp> createState() => _SignWithOtpState();
}

class _SignWithOtpState extends State<SignWithOtp> {
  bool loading = false;
  String phoneNumber = '';

  void sendOtpCode() {
    if (phoneNumber.isEmpty) {
      // Afficher un message à l'utilisateur pour demander de rentrer d'abord un numéro de téléphone valide
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un numéro de téléphone valide.'),
        ),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    final auth = FirebaseAuth.instance;
    authWithPhoneNumber(phoneNumber, onCodeSend: (verificationId, v) {
      setState(() {
        loading = false;
      });
      Navigator.of(context).push(MaterialPageRoute(
        builder: (c) => VerificationOtp(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
        ),
      ));
    }, onAutoVerify: (v) async {
      await auth.signInWithCredential(v);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }, onFailed: (e) {
      print(e);
      setState(() {
        loading = false;
      });
      // Afficher un message à l'utilisateur en cas d'erreur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Le code est erroné.'),
        ),
      );
    }, autoRetrieval: (v) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context); // Action de retour
          },
        ),
        title: const Text(
          "Identification",
          style: TextStyle(color: white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: primary,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Image.asset(
                "assets/images/login1.png", // Chemin vers votre image/logo
                fit: BoxFit.cover,
                width: 200, // Définir la largeur de l'image
                height: 200, // Assurer un ajustement correct de l'image
              ),
              const SizedBox(height: 10),
              const Text(
                "Identifiez vous",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              IntlPhoneField(
                initialCountryCode: "BJ",
                onChanged: (value) {
                  setState(() {
                    phoneNumber = value.completeNumber;
                  });
                },
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey, // Couleur de la bordure
                      width: 1, // Épaisseur de la bordure
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      backgroundColor: Colors.green, // Arrière-plan vert
                      minimumSize:
                          const Size(100, 0), // Largeur minimale du bouton
                    ),
                    onPressed: loading ? null : sendOtpCode,
                    child: loading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          )
                        : const Text(
                            'Se connecter',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white), // Texte blanc
                          ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      text: "Vous n'avez pas de compte ? ",
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Créez un compte',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
