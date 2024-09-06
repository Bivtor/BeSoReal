import 'package:client/login.dart';
import 'package:client/settingsAccount.dart';
import 'package:client/settingsNotifications.dart';
import 'package:client/settingsOther.dart';
import 'package:client/widgets/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

Future<void> _signOut() async {
  await FirebaseAuth.instance.signOut();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login(), settings: const RouteSettings(name: 'Login')));
}

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context),
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Settings group
              _SettingsGroup(
                title: 'Settings',
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Account',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => AccountSettings(), settings: const RouteSettings(name: 'AccountSettings')));
                    },
                  ),
                  _SettingsItem(
                    context,
                    title: 'Notifications',
                    icon: Icons.notifications,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationSettings(), settings: const RouteSettings(name: 'NotificationSettings')));
                    },
                  ),
                  _SettingsItem(
                    context,
                    title: 'Privacy',
                    icon: Icons.lock,
                    onTap: () {
                      
                    },
                  ),
                  _SettingsItem(
                    context,
                    title: 'Other',
                    icon: Icons.more_horiz,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const OtherSettings(), settings: const RouteSettings(name: 'OtherSettings')));
                    },
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // About group
              _SettingsGroup(
                title: 'About',
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Help & Support',
                    icon: Icons.help,
                    onTap: () {
                      
                    },
                  ),
                  _SettingsItem(
                    context,
                    title: 'Terms of Service',
                    icon: Icons.description,
                    onTap: () {
                      
                    },
                  ),
                  _SettingsItem(
                    context,
                    title: 'Privacy Policy',
                    icon: Icons.privacy_tip,
                    onTap: () {
                      
                    },
                  ),
                  
                ],
              ),

              const SizedBox(height: 20),

              _SettingsGroup(
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Sign Out',
                    titleColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    icon: Icons.exit_to_app,
                    onTap: () {
                      _signOut();
                    },
                  ),
                  
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _SettingsGroup(BuildContext context, {required List<Widget> items, String? title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Container(
            color: Colors.grey[850],
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  items[i],
                  if (i < items.length - 1)
                    Divider(color: Colors.grey[700], height: 1), // Divider between items
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _SettingsItem(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap, Color? titleColor, Color? iconColor}) {
  return Material(
        color: Colors.grey[850],
        child: InkWell(
          onTap: onTap,
          child: ListTile(
            title: Text(title, style: TextStyle(color: titleColor ?? Colors.white)),
            leading: Icon(icon, color: iconColor ?? Colors.white),
          ),
        ),
  );
}
  
}
