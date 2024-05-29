import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:mobile_payement_app/theme/color.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    ApiResponse response =
        await login(emailController.text, passwordController.text);
    if (response.error == null) {
      saveAndRedirectToHome(response.data as Account);
    } else {
      setState(() {
        loading = false;
      });
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  // Save and redirect to home
  void saveAndRedirectToHome(Account account) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', account.token ?? '');
    await pref.setInt('accountId', account.id ?? 0);
    // Remplacer par la navigation vers la page d'accueil
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            backgroundBlendMode:
                Theme.of(context).brightness == Brightness.light
                    ? BlendMode.darken
                    : BlendMode.lighten,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).brightness == Brightness.light
                    ? Colors.white
                    : Colors.black,
              ],
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 30.0),
                  child: Text(
                    'Connexion',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 25.0, right: 25.0),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LineIcons.envelope),
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelStyle: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)')
                              .hasMatch(value)) {
                        return 'Veuillez entrer une adresse email valide';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 15.0, left: 25.0, right: 25.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(LineIcons.lock),
                      suffixIcon: IconButton(
                        icon: const Icon(LineIcons.eye),
                        onPressed: () {},
                      ),
                      labelText: 'Mot de passe',
                      labelStyle: const TextStyle(
                        fontSize: 20,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 5 ||
                          value.contains(' ')) {
                        return 'Le mot de passe doit comporter au moins 5 caractères et ne peut pas contenir d\'espaces';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                  child: loading
                      ? const CircularProgressIndicator()
                      : OutlinedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                                loginUser();
                              });
                            }
                          },
                          style: ButtonStyle(
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: 50,
                            child: const Center(
                              child: Text('Se connecter',
                                  style: TextStyle(fontSize: 25)),
                            ),
                          ),
                        ),
                ),
                InkWell(
                  child: Column(
                    children: [
                      const Text("Vous n'avez pas de compte?",
                          style: TextStyle(fontSize: 18)),
                      Text("Inscrivez-vous ici!",
                          style: TextStyle(
                              color: Colors.green[300],
                              fontSize: 18,
                              fontWeight: FontWeight.bold))
                    ],
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/signup');
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
