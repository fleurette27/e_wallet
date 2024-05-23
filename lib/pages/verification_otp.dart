import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_payement_app/function/function_otp.dart';
import 'package:mobile_payement_app/pages/login.dart';
import 'package:mobile_payement_app/theme/color.dart';
import 'package:pinput/pinput.dart';

class VerificationOtp extends StatefulWidget {
  const VerificationOtp(
      {super.key, required this.verificationId, required this.phoneNumber});
  final String verificationId;
  final String phoneNumber;

  @override
  State<VerificationOtp> createState() => _VerificationOtpState();
}

class _VerificationOtpState extends State<VerificationOtp> {
  String smsCode = "";
  bool loading = false;
  bool resend = false;
  int count = 20;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    decompte();
  }

  late Timer timer;

  void decompte() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (count < 1) {
        timer.cancel();
        count = 20;
        resend = true;
        setState(() {});
        return;
      }
      count--;
      setState(() {});
    });
  }

  void onResendSmsCode() {
    resend = false;
    setState(() {});
    authWithPhoneNumber(widget.phoneNumber, onCodeSend: (verificationId, v) {
      loading = false;
      decompte();
      setState(() {});
    }, onAutoVerify: (v) async {
      await _auth.signInWithCredential(v);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    }, onFailed: (e) {
      loading = false;
      setState(() {});
      // ignore: avoid_print
      print("Le code est erroné");
    }, autoRetrieval: (v) {});
  }

  void onVerifySmsCode() async {
    loading = true;
    setState(() {});
    await validateOtp(smsCode, widget.verificationId);
    loading = true;
    setState(() {});
    // ignore: use_build_context_synchronously
    Navigator.push(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    // ignore: avoid_print
    print("Vérification éfectué avec succès");
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
          "Verification",
          style: TextStyle(color: white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: primary,
      ),
      // ignore: deprecated_member_use
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/login1.png", // Chemin vers votre image
                  fit: BoxFit.cover,
                  width: 150, // Définir la largeur de l'image
                  height: 150, // Assurer un ajustement correct de l'image
                ),
                // const SizedBox(height: 10),
                // const Text(
                //   "Verification",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     fontSize: 30,
                //     color: Colors.green,
                //   ),
                // ),
                const SizedBox(height: 10),
                const Text(
                  "Verifier vos messages pour valider",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Pinput(
                  length: 6,
                  onChanged: (value) {
                    smsCode = value;
                    setState(() {});
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: !resend ? null : onResendSmsCode,
                    child: Text(!resend
                        ? "00:${count.toString().padLeft(2, "0")}"
                        : "resend code"),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.green, // Arrière-plan vert
                        minimumSize:
                            const Size(100, 0), // Largeur minimale du bouton
                      ),
                      onPressed: smsCode.length < 6 || loading
                          ? null
                          : onVerifySmsCode,
                      child: loading
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'Verifier',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
