import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatelessWidget {
  final bool isDarkMode;
  final bool areNotificationsEnabled;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<Locale> onLanguageChanged;
  final ValueChanged<bool> onNotificationsChanged;
  final VoidCallback onLogout;

  SettingsPage({
    required this.isDarkMode,
    required this.areNotificationsEnabled,
    required this.onThemeChanged,
    required this.onLanguageChanged,
    required this.onNotificationsChanged,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0B698B),
                Color(0xFF0396A6),
                Color(0xFF9CD3D8),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            subtitle: const Text('Privacy, security, and account info'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification settings'),
            trailing: Switch(
              value: areNotificationsEnabled,
              onChanged: onNotificationsChanged,
              activeColor: const Color(0xFF0396A6), // Active switch color
              inactiveThumbColor: Colors.grey, // Inactive thumb color
              inactiveTrackColor: Colors.grey.shade400, // Inactive track color
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            subtitle: const Text('Select your preferred language'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          SwitchListTile(
            value: isDarkMode,
            onChanged: onThemeChanged,
            title: const Text('Dark Mode'),
            secondary: const Icon(Icons.dark_mode),
            activeColor: const Color(0xFF0396A6), // Active switch color
            inactiveThumbColor: Colors.grey, // Inactive thumb color
            inactiveTrackColor: Colors.grey.shade400, // Inactive track color
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help & Support'),
            subtitle: const Text('FAQs, contact us'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final List<Locale> locales = [
      Locale('en', ''),
      Locale('ar', ''),
      Locale('fr', ''),
      Locale('es', ''),
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: locales.map((Locale locale) {
                return ListTile(
                  title: Text(locale.languageCode == 'en'
                      ? 'English'
                      : locale.languageCode == 'ar'
                      ? 'العربية'
                      : locale.languageCode == 'fr'
                      ? 'Français'
                      : 'Español'),
                  onTap: () {
                    onLanguageChanged(locale);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
          ],
        );
      },
    );
  }
}
