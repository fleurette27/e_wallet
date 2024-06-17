import 'dart:async';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:mobile_payement_app/pages/email_reset_password.dart';
import 'package:mobile_payement_app/pages/reset_password.dart';
import 'package:mobile_payement_app/pages/about.dart';
import 'package:mobile_payement_app/pages/edit_profil.dart';
import 'package:mobile_payement_app/pages/help.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/login.dart';
import 'package:mobile_payement_app/pages/setting.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/transaction_history.dart';
import 'package:mobile_payement_app/pages/welcome.dart';
import 'package:mobile_payement_app/utils/theme.dart';
import 'package:mobile_payement_app/utils/theme_manager.dart';

void main() async {
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
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    themeManager.addListener(themeListener);
    initAppLinks();
  }

  @override
  void dispose() {
    themeManager.removeListener(themeListener);
    _sub?.cancel();
    super.dispose();
  }

  Future<void> initAppLinks() async {
    _sub = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        if (uri.path == '/reset-password') {
          String? token = uri.queryParameters['token'];
          if (token != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PasswordResetPage(token: token),
              ),
            );
          }
        }
      }
    });
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
        '/transactions': (context) => const TransactionHistory(),
        '/email-reset': (context) => const EmailResetPage(),
        '/reset-password': (context) => const PasswordResetPage(token: ''),
      },
      title: 'SeedPay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeManager.themeMode,
      home: const Welcome(),
    );
  }
}
