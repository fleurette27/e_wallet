import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mobile_payement_app/firebase_options.dart';
import 'package:mobile_payement_app/pages/about.dart';
import 'package:mobile_payement_app/pages/edit_profil.dart';
import 'package:mobile_payement_app/pages/help.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/login.dart';
import 'package:mobile_payement_app/pages/profile.dart';
import 'package:mobile_payement_app/pages/setting.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/transaction_history.dart';
import 'package:mobile_payement_app/pages/welcome.dart';
import 'package:mobile_payement_app/utils/theme.dart';
import 'package:mobile_payement_app/utils/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const App());
}

ThemeManager themeManager = ThemeManager();

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    themeManager.addListener(themeListener);
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/help': (context) => const HelpScreen(),
        '/about': (context) => const AboutScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/edit': (context) => const EditProfile(),
        '/transactions': (context) =>const TransactionHistory(),
        '/profile':(context) => const ProfileScreen(),
      },
      title: 'SeedPay',
      theme:AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      home: const Welcome(),
    );
  }
}
