import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mobile_payement_app/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
    bool isDark = themeManager.themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paramètres"),
        actions: [
          IconButton(
              icon: Icon(isDark ? LineIcons.sun : LineIcons.moon),
              onPressed: () {
                themeManager.toggleTheme(isDark);
              },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Paramètres de confidentialité",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Politique de confidentialité"),
              onTap: () {
                // Naviguer vers la page de la politique de confidentialité
              },
            ),
            ListTile(
              title: const Text("Conditions d'utilisation"),
              onTap: () {
                // Naviguer vers la page des conditions d'utilisation
              },
            ),
            const Divider(),
            const Text(
              "Autres paramètres",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Notifications"),
              onTap: () {
                // Naviguer vers la page des paramètres de notification
              },
            ),
            ListTile(
              title: const Text("Langue"),
              onTap: () {
                // Naviguer vers la page des paramètres de langue
              },
            ),
            
          ],
        ),
      ),
    );
  }
}
