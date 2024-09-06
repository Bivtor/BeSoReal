import 'package:client/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key});

  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {

  Map<String, bool> notifications = {};

    @override
  void initState() {

    // Load settings from local storage
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        notifications['Time to post'] = prefs.getBool('Time to post') ?? true;
        notifications['Friend Posts'] = prefs.getBool('Friend Posts') ?? true;
        notifications['Friend Requests'] = prefs.getBool('Friend Requests') ?? true;
        notifications['Mentions'] = prefs.getBool('Mentions') ?? true;
        notifications['Comments'] = prefs.getBool('Comments') ?? true;
        notifications['Reactions'] = prefs.getBool('Reactions') ?? true;
      });
    });

    super.initState();
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
              _SettingsGroup(
                title: 'Posts',
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Time to post',
                    icon: Icons.alarm,
                  ),
                  _SettingsItem(
                    context,
                    title: 'Friend Posts',
                    icon: Icons.notifications_active,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _SettingsGroup(
                title: 'Other',
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Friend Requests',
                    icon: Icons.person_add,
                  ),
                  _SettingsItem(
                    context,
                    title: 'Mentions',
                    icon: Icons.alarm_on,
                  ),
                  _SettingsItem(
                    context,
                    title: 'Comments',
                    icon: Icons.comment,
                  ),
                  _SettingsItem(
                    context,
                    title: 'Reactions',
                    icon: Icons.favorite,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    // save settings to shared preferences
                    SharedPreferences.getInstance().then((prefs) {
                      prefs.setBool('Time to post', notifications['Time to post']!);
                      prefs.setBool('Friend Posts', notifications['Friend Posts']!);
                      prefs.setBool('Friend Requests', notifications['Friend Requests']!);
                      prefs.setBool('Mentions', notifications['Mentions']!);
                      prefs.setBool('Comments', notifications['Comments']!);
                      prefs.setBool('Reactions', notifications['Reactions']!);
                    });

                    // toast
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings saved')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _SettingsGroup(BuildContext context,
      {required List<Widget> items, String? title}) {
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
                    Divider(
                        color: Colors.grey[700],
                        height: 1), // Divider between items
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _SettingsItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    VoidCallback? onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    if (!notifications.containsKey(title)) {
      notifications[title] = false;
    }

    onTap ??= () {
        setState(() {
          notifications[title] = !notifications[title]!;
        });
      };

    onToggle(bool value) {
      setState(() {
        notifications[title] = value;
      });
    }

    bool isSwitched = notifications[title]!;

    return Material(
      color: Colors.grey[850],
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title:
              Text(title, style: TextStyle(color: titleColor ?? Colors.white)),
          leading: Icon(icon, color: iconColor ?? Colors.white),
          // The toggle switch added here
          trailing: Switch(
                  value: isSwitched,
                  onChanged: onToggle,
                  activeColor: Colors.blue, // Customize the color if needed
                ), // Show the switch only when required
        ),
      ),
    );
  }
}
