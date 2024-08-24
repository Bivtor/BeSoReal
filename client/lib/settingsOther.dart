import 'package:client/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class OtherSettings extends StatefulWidget {
  const OtherSettings({super.key});

  @override
  State<OtherSettings> createState() => _OtherSettingsState();
}

class _OtherSettingsState extends State<OtherSettings> {

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
                title: 'Other',
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Clear Cache',
                    icon: Icons.delete,
                    onTap: () async {
                      // clear cache

                      if (Theme.of(context).platform == TargetPlatform.windows) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Cache clearing is not supported on Windows'),
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      }

                      try {
                      // Get the cache directory path
                      final cacheDir = await getTemporaryDirectory();
                      if (cacheDir.existsSync()) {
                        cacheDir.deleteSync(recursive: true);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Cache cleared'),
                          duration: Duration(seconds: 3),
                        ));
                      }
                      await DefaultCacheManager().emptyCache();
                    } catch (e) {
                      print(e);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('An error occurred while clearing the cache'),
                        duration: Duration(seconds: 3),
                      ));
                    }

                    },
                  ),
                ],
              ),

              SizedBox(height: 20),

              _SettingsGroup(
                context,
                items: [
                  _SettingsItem(
                    context,
                    title: 'Delete Account',
                    titleColor: Colors.redAccent,
                    iconColor: Colors.redAccent,
                    icon: Icons.delete_forever,
                    onTap: () {
                      
                      // TODO delete account

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
            style: TextStyle(
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
