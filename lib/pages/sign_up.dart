// SignUpScreen

import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/pages/signup_verification_otp.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String phoneNumber = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void registerAccount() async {
    setState(() {
      _isLoading = true;
    });

    ApiResponse response = await register(
      _nameController.text,
      _surnameController.text,
      _emailController.text,
      _passwordController.text,
      phoneNumber,
    );

    setState(() {
      _isLoading = false;
    });

    if (response.error == null) {
      saveAndRedirectToHome(response.data as Account);
    } else {
      if (context.mounted) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  void saveAndRedirectToHome(Account account) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', account.token ?? '');
    await pref.setInt('accountId', account.id ?? 0);

    if (context.mounted) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (context) => const VerifyOtpSignUp(
                )),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crée ton compte'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_pageController.page == 0) {
              Navigator.pop(context);
            } else {
              _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            }
          },
        ),
      ),
      body: PageView(
              controller: _pageController,
              children: [
                buildPhoneNumberPage(),
                buildInformationPage(),
              ],
            ),
    );
  }

  Widget buildPhoneNumberPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Veuillez saisir votre numéro',
              style: TextStyle(fontSize: 18)),
          const SizedBox(height: 20),
          IntlPhoneField(
            controller: _phoneController,
            initialCountryCode: "BJ",
            onChanged: (value) {
              setState(() {
                phoneNumber = value.completeNumber;
              });
            },
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelStyle: const TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue[900]
                  : Colors.green[800],
            ),
            child: const Text(
              'Continuer',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInformationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTextField(_nameController, 'Nom', Icons.person),
          const SizedBox(height: 20),
          buildTextField(_surnameController, 'Prénom', Icons.person),
          const SizedBox(height: 20),
          buildTextField(_emailController, 'E-mail', Icons.email),
          const SizedBox(height: 20),
          buildPasswordField(_passwordController, 'Mot de passe'),
          const SizedBox(height: 20),
          buildPasswordField(
              _confirmPasswordController, 'Confirmez votre mot de passe'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isLoading ? null : registerAccount,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.blue[900]
                  : Colors.green[800],
            ), // Disable the button during loading
            child: _isLoading
                ? const CircularProgressIndicator() // Show loading indicator
                : const Text(
                    'Créer mon compte',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Text(
            'En continuant, j\'accepte la Politique de confidentialité de SeedPay, ainsi que les conditions générales.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildTextField(
      TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.visibility_off),
      ),
    );
  }
}
