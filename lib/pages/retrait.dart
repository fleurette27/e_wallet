import 'package:flutter/material.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/payout_benin.dart';
import 'package:mobile_payement_app/pages/payout_togo.dart';

class RetraitPage extends StatelessWidget {
  const RetraitPage({super.key});

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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Retirer votre argent sur mobile money en provenance du Bénin',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Image.asset(
              'assets/images/Flag_of_Benin.svg.png',
              width: 70,
              height: 70,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PayoutBeninFeexpay(),
                  ),
                );
              },
              child: const Text('Bénin'),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Retirer votre argent sur mobile money en provenance du Togo',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Image.asset(
              'assets/images/Flag_of_Togo.svg.png',
              width: 70,
              height: 70,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PayoutTogoFeexpay(),
                  ),
                );
              },
              child: const Text('Togo'),
            ),
          ],
        ),
      ),
    );
  }
}
