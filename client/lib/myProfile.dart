import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';
import 'package:client/widgets/myPosts.dart';

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
    return Scaffold(
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
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                // My Username
                // TODO add data fetching
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Lebron James',
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
                      fontSize: 26.0, // Set the font size larger than normal
                      fontWeight: FontWeight.bold, // Make the text bold
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AllMyPosts(context),
                ), // History of my posts from the AllMyPosts widget
                // TODO pass data from firebase, as well as add argument to accept posts[] object
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
      );
  }
}

// IconButton(
//                     icon: const Icon(Icons.settings, color: Colors.white),
//                     onPressed: () => {
//                       // go to settings page
//                     },
//                   ),
