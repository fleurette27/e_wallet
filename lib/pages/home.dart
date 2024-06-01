import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/main.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/convert.dart';
import 'package:mobile_payement_app/pages/deposit.dart';
// import 'package:mobile_payement_app/pages/feexpay.dart';
import 'package:mobile_payement_app/pages/login.dart';
import 'package:mobile_payement_app/pages/overview.dart';
import 'package:mobile_payement_app/pages/retrait.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/transfert.dart';
// import 'package:mobile_payement_app/pages/withdraw.dart';
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
    const Overview(), //vue d'ensemble
    const Deposit(), //depot
    const RetraitPage(), //retrait
    const Transfer(), //transfert
    const Convert(), //convertisseur
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
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: _pages[page],
      endDrawer: getDrawer(),
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

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.lightGreen[900],
            ),
            child: ListTile(
              leading: const Icon(Icons.account_circle),
              title: Text('$name'),
              // subtitle: const Text('Numero de compte'),
            ),
          ),
          ProfileMenuWidget(
              title: "Profil",
              icon: LineIcons.alternatePencil,
              onPress: () {
                Navigator.pushNamed(context, '/edit');
              }),
          ProfileMenuWidget(
              title: "Paramètre",
              icon: LineIcons.cog,
              onPress: () {
                Navigator.pushNamed(context, "/settings");
              }),
          ProfileMenuWidget(
              title: "Aide",
              icon: LineIcons.questionCircle,
              onPress: () {
                Navigator.pushNamed(context, '/help');
              }),
          ProfileMenuWidget(
              title: "A Propos",
              icon: LineIcons.infoCircle,
              onPress: () {
                Navigator.pushNamed(context, '/about');
              }),
          ProfileMenuWidget(
              title: "Deconnexion",
              icon: LineIcons.alternateSignOut,
              onPress: () {
                logout().then((value) => {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false)
                    });
              },
              endIcon: false,
              textColor: Colors.red),
        ],
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    var isDark = themeManager.themeMode == ThemeMode.dark;
    var iconColor = isDark ? Colors.blue : Colors.green;
    return ListTile(
        onTap: onPress,
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100)),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, color: textColor),
        ),
        trailing: endIcon
            ? Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100)),
                child: const Icon(
                  LineIcons.angleRight,
                  color: Colors.grey,
                  size: 18,
                ),
              )
            : null);
  }
}
