import 'package:feexpay_flutter/feexpay_flutter.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';

class FeexPay extends StatefulWidget {
  const FeexPay({super.key});

  @override
  State<FeexPay> createState() => _FeexPayState();
}

class _FeexPayState extends State<FeexPay> {

  String randomString = randomAlphaNumeric(15);
  String amount = '20';

  @override
  Widget build(BuildContext context) {
   return Scaffold(
   body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: const Color(0xFF112C56),
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),),
                onPressed: () => {
                // print(randomString)
                Navigator.push(
                  context,
                    MaterialPageRoute(builder: (context) => ChoicePage(
                      token: 'fp_he0e0lL6Q5VyAu7znX1j3aXgkgVs3UtZVOZSCEG7VSP8pgjFWajZtd4oRb6XjFw9',
                      id: '6658f684de449872c1dfe91b',
                      amount: amount,
                      redirecturl: '/home',
                      trans_key: randomString,
                      callback_info: '{"id","fvjinduhghbuyfjhfdg"}',
                    )),
                  )
                },
              child: Text('Payer $amount')
            ),
          ],
        ),
      ),
    );
  }
}