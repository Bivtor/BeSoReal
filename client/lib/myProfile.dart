import 'package:client/widgets/myPosts.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  // final TextEditingController _usernameController = TextEditingController();
  String? _usernameError;
  String? _username;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: Header(context),
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 75.0,
                  backgroundImage: AssetImage('avatar.png'),
                ),
                Text('$_username'), // My Username
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: AllMyPosts(),
                ),
                if (_usernameError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      _usernameError!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// IconButton(
//                     icon: const Icon(Icons.settings, color: Colors.white),
//                     onPressed: () => {
//                       // go to settings page
//                     },
//                   ),