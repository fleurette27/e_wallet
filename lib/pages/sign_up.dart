import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/pages/home.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/theme/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  DateTime? birthDate;
  String phoneNumber = '';
  bool loading = false;
  int currentStep = 0;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void registerAccount() async {
    if (birthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner votre date de naissance')),
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      }
    }
  }

  void saveAndRedirectToHome(Account account) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', account.token ?? '');
    await pref.setInt('accountId', account.id ?? 0);

    if (context.mounted) {
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

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            backgroundBlendMode: Theme.of(context).brightness == Brightness.light
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
              Stepper(
              currentStep: currentStep,
              onStepTapped: (step) => setState(() => currentStep = step),
              onStepContinue: () {
                if (currentStep < 2) {
                  setState(() => currentStep += 1);
                } else {
                  if (formKey.currentState?.validate() ?? false) {
                    registerAccount();
                  }
                }
              },
              onStepCancel: currentStep == 0
                  ? null
                  : () => setState(() => currentStep -= 1),
              steps: [
                Step(
                  title: const Text('Informations personnelles'),
                  content: Column(
                    children: [
                      TextFormField(
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
                              !value.contains(' ') ||
                              value.length < 10 ||
                              !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                            return 'Veuillez entrer votre nom complet';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                          if (value == null ||
                              value.isEmpty ||
                              !RegExp(
                                      r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)*$')
                                  .hasMatch(value)) {
                            return 'Veuillez entrer une adresse email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey,
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime(2000),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (newDate != null) {
                              setState(() {
                                birthDate = newDate;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                const Icon(LineIcons.calendar, size: 30),
                                Text(
                                  birthDate == null
                                      ? 'Date de naissance'
                                      : 'Date de naissance: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  isActive: currentStep >= 0,
                  state: currentStep > 0 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Numéro de téléphone'),
                  content: Column(
                    children: [
                      IntlPhoneField(
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
                    ],
                  ),
                  isActive: currentStep >= 1,
                  state: currentStep > 1 ? StepState.complete : StepState.indexed,
                ),
                Step(
                  title: const Text('Mot de passe'),
                  content: Column(
                    children: [
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(LineIcons.lock),
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          labelStyle: const TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 8) {
                            return 'Le mot de passe doit comporter au moins 8 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
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
                          if (value != passwordController.text) {
                            return 'Les mots de passe ne correspondent pas';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                  isActive: currentStep >= 2,
                  state: currentStep == 2 ? StepState.indexed : StepState.complete,
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    currentStep == 0
                        ? Container()
                        : TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Retour'),
                          ),
                    currentStep == 2 && loading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: details.onStepContinue,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: primary,
                            ),
                            child: Text(
                              currentStep == 2 ? 'S\'inscrire' : 'Suivant',
                              style: const TextStyle(
                                fontSize: 20,
                                color: white,
                              ),
                            ),
                          ),
                  ],
                );
              },
            ),
              ],
          ),
        ),
      ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';
// import 'package:line_icons/line_icons.dart';
// import 'package:mobile_payement_app/pages/home.dart';
// import 'package:mobile_payement_app/services/account_service.dart';
// import 'package:mobile_payement_app/models/account.dart';
// import 'package:mobile_payement_app/models/api_response.dart';
// import 'package:mobile_payement_app/theme/color.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class SignUpScreen extends StatefulWidget {
//   const SignUpScreen({Key? key});

//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneNumberController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   DateTime? birthDate;
//   String phoneNumber = '';
//   bool loading = false;
//   int currentStep = 0;

//   @override
//   void dispose() {
//     nameController.dispose();
//     emailController.dispose();
//     phoneNumberController.dispose();
//     passwordController.dispose();
//     confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void registerAccount() async {
//     if (birthDate == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Veuillez sélectionner votre date de naissance')),
//       );
//       return;
//     }

//     setState(() {
//       loading = true;
//     });

//     ApiResponse response = await register(
//       nameController.text,
//       emailController.text,
//       passwordController.text,
//       phoneNumber,
//       birthDate!,
//     );

//     if (response.error == null) {
//       saveAndRedirectToHome(response.data as Account);
//     } else {
//       setState(() {
//         loading = false;
//       });
//       if (context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
//       }
//     }
//   }

//   void saveAndRedirectToHome(Account account) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString('token', account.token ?? '');
//     await pref.setInt('accountId', account.id ?? 0);

//     if (context.mounted) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const HomeScreen()),
//         (route) => false,
//       );
//     }
//   }

//   void goToNextStep() {
//     if (formKey.currentState?.validate() ?? false) {
//       if (currentStep < 2) {
//         setState(() {
//           currentStep += 1;
//         });
//       } else {
//         registerAccount();
//       }
//     }
//   }

//   void goToPreviousStep() {
//     if (currentStep > 0) {
//       setState(() {
//         currentStep -= 1;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           decoration: BoxDecoration(
//             backgroundBlendMode: Theme.of(context).brightness == Brightness.light
//                 ? BlendMode.darken
//                 : BlendMode.lighten,
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.center,
//               colors: [
//                 Theme.of(context).primaryColor,
//                 Theme.of(context).brightness == Brightness.light
//                     ? Colors.white
//                     : Colors.black,
//               ],
//             ),
//           ),
//           child: Form(
//             key: formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 SizedBox(
//                   height: 150,
//                   width: 150,
//                   child: ClipOval(
//                     child: Image.asset(
//                       'assets/images/logo.png',
//                       height: 150,
//                       width: 150,
//                     ),
//                   ),
//                 ),
//                 if (currentStep == 0)
//                   PersonalInfoStep(
//                     nameController: nameController,
//                     emailController: emailController,
//                     birthDate: birthDate,
//                     onBirthDateChanged: (newDate) {
//                       setState(() {
//                         birthDate = newDate;
//                       });
//                     },
//                   ),
//                 if (currentStep == 1)
//                   PhoneNumberStep(
//                     phoneNumberController: phoneNumberController,
//                     onPhoneNumberChanged: (value) {
//                       setState(() {
//                         phoneNumber = value.completeNumber;
//                       });
//                     },
//                   ),
//                 if (currentStep == 2)
//                   PasswordStep(
//                     passwordController: passwordController,
//                     confirmPasswordController: confirmPasswordController,
//                   ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     currentStep == 0
//                         ? Container()
//                         : TextButton(
//                             onPressed: goToPreviousStep,
//                             child: const Text('Retour'),
//                           ),
//                     currentStep == 2 && loading
//                         ? const CircularProgressIndicator()
//                         : ElevatedButton(
//                             onPressed: goToNextStep,
//                             style: ElevatedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 50, vertical: 20),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               backgroundColor: primary,
//                             ),
//                             child: Text(
//                               currentStep == 2 ? 'S\'inscrire' : 'Suivant',
//                               style: const TextStyle(
//                                 fontSize: 20,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PersonalInfoStep extends StatelessWidget {
//   final TextEditingController nameController;
//   final TextEditingController emailController;
//   final DateTime? birthDate;
//   final Function(DateTime?) onBirthDateChanged;

//   const PersonalInfoStep({
//     Key? key,
//     required this.nameController,
//     required this.emailController,
//     required this.birthDate,
//     required this.onBirthDateChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: nameController,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(LineIcons.user),
//             labelText: 'Nom complet',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             labelStyle: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           validator: (value) {
//             if (value == null ||
//                 value.isEmpty ||
//                 !value.contains(' ') ||
//                 value.length < 10 ||
//                 !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
//               return 'Veuillez entrer votre nom complet';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: emailController,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(LineIcons.envelope),
//             labelText: 'Email',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             labelStyle: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           validator: (value) {
//             if (value == null ||
//                 value.isEmpty ||
//                 !RegExp(
//                         r'^.+@[a-zA-Z]+\.[a-zA-Z]+(\.{0,1}[a-zA-Z]+)*$')
//                     .hasMatch(value)) {
//               return 'Veuillez entrer une adresse email valide';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 10),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: Colors.grey,
//             ),
//           ),
//           child: InkWell(
//             onTap: () async {
//               DateTime? newDate = await showDatePicker(
//                 context: context,
//                 initialDate: DateTime(2000),
//                 firstDate: DateTime(1900),
//                 lastDate: DateTime.now(),
//               );
//               if (newDate != null) {
//                 onBirthDateChanged(newDate);
//               }
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Row(
//                 children: [
//                   const Icon(LineIcons.calendar, size: 30),
//                   Text(
//                     birthDate == null
//                         ? 'Date de naissance'
//                         : 'Date de naissance: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PhoneNumberStep extends StatelessWidget {
//   final TextEditingController phoneNumberController;
//   final Function(IntlPhoneField) onPhoneNumberChanged;

//   const PhoneNumberStep({
//     Key? key,
//     required this.phoneNumberController,
//     required this.onPhoneNumberChanged,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         IntlPhoneField(
//           controller: phoneNumberController,
//           initialCountryCode: "BJ",
//           onChanged: (value) {
//             onPhoneNumberChanged(value);
//           },
//           decoration: const InputDecoration(
//             border: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.grey,
//                 width: 1,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class PasswordStep extends StatelessWidget {
//   final TextEditingController passwordController;
//   final TextEditingController confirmPasswordController;

//   const PasswordStep({
//     Key? key,
//     required this.passwordController,
//     required this.confirmPasswordController,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextFormField(
//           controller: passwordController,
//           obscureText: true,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(LineIcons.lock),
//             labelText: 'Mot de passe',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             labelStyle: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           validator: (value) {
//             if (value == null || value.isEmpty || value.length < 8) {
//               return 'Le mot de passe doit comporter au moins 8 caractères';
//             }
//             return null;
//           },
//         ),
//         const SizedBox(height: 10),
//         TextFormField(
//           controller: confirmPasswordController,
//           obscureText: true,
//           decoration: InputDecoration(
//             prefixIcon: const Icon(LineIcons.lock),
//             labelText: 'Confirmer le mot de passe',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(20),
//             ),
//             labelStyle: const TextStyle(
//               fontSize: 20,
//             ),
//           ),
//           validator: (value) {
//             if (value != passwordController.text) {
//               return 'Les mots de passe ne correspondent pas';
//             }
//             return null;
//           },
//         ),
//       ],
//     );
//   }
// }
