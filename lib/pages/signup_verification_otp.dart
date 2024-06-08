// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:pinput/pinput.dart';
import 'dart:async';

class VerifyOtpSignUp extends StatefulWidget {
  const VerifyOtpSignUp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VerifyOtpSignUpState createState() => _VerifyOtpSignUpState();
}

class _VerifyOtpSignUpState extends State<VerifyOtpSignUp> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  int _start = 180;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });
    int id = await getUserId();

    final response = await verifyOtp(
      id,
      int.parse(_otpController.text),
    );

    setState(() {
      _isLoading = false;
    });

    if (response['message'] == 'OTP vérifié avec succès.') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Erreur inconnue')),
      );
    }
  }

  void _resendOtp() async {
    setState(() {
      _isLoading = true;
    });
    int id = await getUserId();

    final response = await resendOtp(id);

    setState(() {
      _isLoading = false;
      _start = 180; // reset timer
      startTimer();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? 'Erreur inconnue')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valider votre email en renseignant l\'OTP'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Pinput(
                    controller: _otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue[900]
                              : Colors.green[800],
                    ),
                    onPressed: _verifyOtp,
                    child: const Text(
                      'Vérifier',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _start == 0
                      ? TextButton(
                          onPressed: _resendOtp,
                          child: const Text('Renvoyer OTP'),
                        )
                      : Text('Renvoyer OTP dans $_start secondes'),
                ],
              ),
            ),
    );
  }
}
