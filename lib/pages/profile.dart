import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/pages/login.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import '../main.dart';
import '../models/Account.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nameController;
  String? emailController;
  String? phoneNumberController;

  Account? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as Account;
        nameController = user!.name ?? '';
        emailController = user!.email ?? '';
        phoneNumberController = user!.phoneNumber ?? '';
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
  Widget build(BuildContext context) {
    bool isDark = themeManager.themeMode == ThemeMode.dark;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(LineIcons.angleLeft),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: Icon(isDark ? LineIcons.sun : LineIcons.moon),
              onPressed: () {
                themeManager.toggleTheme(isDark);
              },
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.all(20),
                child: user == null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    : Column(children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.7),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                              'assets/images/man.png',
                                            ),
                                            fit: BoxFit.cover))),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ProfileMenuWidget(
                                title: "",
                                icon: LineIcons.alternatePencil,
                                onPress: () {
                                  Navigator.pushNamed(context, '/edit');
                                },
                                endIcon: false,
                                textColor: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(nameController ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            )),
                        Text(emailController ?? '',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.grey)),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                            width: 200,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/edit');
                              },
                              style: OutlinedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? const Color(0xFFFFD23F)
                                      : const Color(0xFF5EBC66),
                                  shape: const StadiumBorder()),
                              child: const Text("Edit Profile",
                                  style: TextStyle(fontSize: 18)),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 10,
                        ),
                        ProfileMenuWidget(
                            title: "Settings",
                            icon: LineIcons.cog,
                            onPress: () {
                              Navigator.pushNamed(context, "/settings");
                            }),
                        ProfileMenuWidget(
                            title: "Billing Details",
                            icon: LineIcons.creditCard,
                            onPress: () {
                              Navigator.pushNamed(context, '/billing');
                            }),
                        ProfileMenuWidget(
                            title: "Help",
                            icon: LineIcons.questionCircle,
                            onPress: () {
                              Navigator.pushNamed(context, '/help');
                            }),
                        ProfileMenuWidget(
                            title: "About",
                            icon: LineIcons.infoCircle,
                            onPress: () {
                              Navigator.pushNamed(context, '/about');
                            }),
                        ProfileMenuWidget(
                            title: "Logout",
                            icon: LineIcons.alternateSignOut,
                            onPress: () {
                              logout().then((value) => {
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                        (route) => false)
                                  });
                            },
                            endIcon: false,
                            textColor: Colors.red),
                      ]))));
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
    var iconColor = isDark ? Colors.yellow : Colors.green;
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
