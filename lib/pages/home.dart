import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/convert.dart';
import 'package:mobile_payement_app/pages/deposit.dart';
import 'package:mobile_payement_app/pages/overview.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/transfert.dart';
import 'package:mobile_payement_app/pages/withdraw.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:mobile_payement_app/services/account_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 0;
  final List<Widget> _pages = [
    const Overview(),//vue d'ensemble
    const Deposit(),//depot
    const Withdrawal(),//retrait
    const Transfer(),//transfert
    const Convert(),//convertisseur
  ];
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

    String? name;
    Account? user;

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as Account;
        name = user!.name ?? '';
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

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
                    'Bon retour $name,',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  LineIcons.userCircle,
                  size: 30,
                  color: Theme.of(context).primaryColor.withOpacity(0.7),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
            )
          ]),
      body: _pages[page],
      bottomNavigationBar: CurvedNavigationBar(
        items: const [
          Icon(LineIcons.home),
          Icon(LineIcons.wallet),
          Icon(LineIcons.coins),
          Icon(LineIcons.paperPlane),
          Icon(LineIcons.euroSign),
        ],
        color: Theme.of(context).primaryColor.withOpacity(0.7),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 500),
        height: 60,
        key: _bottomNavigationKey,
        index: page,
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
        letIndexChange: (value) => true,
      ),
    );
  }
}
