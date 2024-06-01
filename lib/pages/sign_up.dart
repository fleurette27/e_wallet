import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/pages/home.dart';
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
  final PageController _pageController = PageController();
 final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  DateTime? birthDate;
  String phoneNumber = '';
  bool loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != birthDate) {
      setState(() {
        birthDate = pickedDate;
      });
    }
  }

  void registerAccount() async {
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Veuillez sélectionner votre date de naissance')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    ApiResponse response = await register(
      nameController.text,
      emailController.text,
      passwordController.text,
      phoneNumber,
      birthDate!,
    );

    if (response.error == null) {
      saveAndRedirectToHome(response.data as Account);
    } else {
      setState(() {
        loading = false;
      });
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
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: PageView(
        controller: _pageController,
        children: [
          _buildPage1(context),
          _buildPage2(context),
        ],
      ),
    );
  }

  Widget _buildPage1(BuildContext context) {
   return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form( // Utilisez le widget Form pour associer la clé de formulaire
          key: formKey, // Associez la clé de formulaire ici
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
                'Inscription',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(LineIcons.user),
                  labelText: 'Nom complet',
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
                      value.length < 10||
                      !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Veuillez entrer votre nom complet';
                  }
                  return null;
                },
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: GestureDetector(
                onTap: () {
                  _selectDate(context);
                },
                child: TextFormField(
                  enabled: false, // Désactiver la saisie directe dans le champ
                  controller: TextEditingController(
                    text: birthDate == null
                        ? 'Date de naissance'
                        : 'Date de naissance: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                  ),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(LineIcons.calendar),
                    labelText: 'Date de naissance',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    labelStyle: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  style: const TextStyle(fontSize: 20), // Style du texte
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: IntlPhoneField(
                controller: phoneNumberController,
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
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease,
                  );
                }
              },
              child: const Text('Suivant'),
            ),
          ],
        ),
      ),
      ),
    );
  }
Widget _buildPage2(BuildContext context) {
  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centrer les enfants horizontalement
        children: <Widget>[
          const SizedBox(height: 20), // Espacement par rapport au haut de la page
          const Text(
            'Vos informations de connexion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20), // Espacement entre le titre et les champs
          TextFormField(
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
              // Validation du champ email
              if (value == null ||
                  value.isEmpty ||
                  !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)')
                      .hasMatch(value)) {
                return 'Veuillez entrer une adresse email valide';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Espacement entre les champs
          TextFormField(
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
              // Validation du champ mot de passe
              if (value == null ||
                  value.isEmpty ||
                  value.length < 5 ||
                  value.contains(' ')) {
                return 'Le mot de passe doit comporter au moins 5 caractères et ne peut pas contenir d\'espaces';
              }
              return null;
            },
          ),
          const SizedBox(height: 10), // Espacement entre les champs
          TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              prefixIcon: const Icon(LineIcons.lock),
              labelText: 'Confirmer le mot de passe',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              labelStyle: const TextStyle(
                fontSize: 20,
              ),
            ),
            validator: (value) {
              // Validation du champ de confirmation du mot de passe
              if (value != passwordController.text) {
                return 'Les mots de passe ne correspondent pas';
              }
              return null;
            },
          ),
          const SizedBox(height: 20), // Espacement entre les champs et le bouton
          loading
              ? const CircularProgressIndicator()
              : OutlinedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                        registerAccount();
                      });
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 50,
                    child: const Center(
                      child: Text('S\'inscrire', style: TextStyle(fontSize: 25)),
                    ),
                  ),
                ),
          const SizedBox(height: 10), // Espacement entre le bouton et le texte de connexion
          InkWell(
            child: const Column(
              children: [
                Text("Vous avez déjà un compte?", style: TextStyle(fontSize: 18)),
                Text("Connectez-vous ici!",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
          const SizedBox(height: 10), // Espacement entre le texte de connexion et le bouton retour
          ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            },
            child: const Text('Retour'),
          ),
        ],
      ),
    ),
  );
}

}
