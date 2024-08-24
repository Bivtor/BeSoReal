import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  final _displayNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  String username = '';
  String displayName = '';
  String email = '';
  String photoURL = '';

  // Get the current user's display name and email
  @override
  void initState() {

    FirebaseFirestore.instance.collection('userdata').doc(FirebaseAuth.instance.currentUser?.uid).get().then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          username = documentSnapshot.get('username');
        });
      }
    });

    displayName = FirebaseAuth.instance.currentUser?.displayName ?? '';
    email = FirebaseAuth.instance.currentUser?.email ?? '';
    photoURL = FirebaseAuth.instance.currentUser?.photoURL ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(context),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/avatar.png'),
                    backgroundColor: Colors.grey[800],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () async {

                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result != null) {
                          File file = File(result.files.single.path!);
                          print(file);
                          // TODO upload to AWS, send new link to Firebase
                        }

                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Display Name Text Field
            _buildTextField(
              controller: _displayNameController,
              labelText: 'Display Name',
              hintText: 'Enter your display name',
              defaultValue: displayName,
            ),
            SizedBox(height: 16),

            // Username Text Field
            _buildTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter your username',
              defaultValue: username,
            ),
            SizedBox(height: 24),

            // Email Text Field
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              editable: false,
              defaultValue: email,
            ),
            SizedBox(height: 24),

            // Save Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {

                    // firebase save
                    FirebaseAuth.instance.currentUser?.updateDisplayName(_displayNameController.text);
                    FirebaseFirestore.instance.collection('userdata').doc(FirebaseAuth.instance.currentUser?.uid).update({
                      'username': _usernameController.text,
                    });
                    //FirebaseAuth.instance.currentUser?.updateEmail(_usernameController.text);

                    // toast message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account settings saved'),
                      ),
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
                  child: const Text('Save',
                      style: TextStyle(color: Colors.white)),
                ),
              ),

          ],
        ),
      ),
    );
  }

  // Builds a text field with the specified controller and label
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    String hintText = '',
    bool editable = true,
    String defaultValue = ''
  }) {
    controller.text = defaultValue;
    return TextField(
      enabled: editable,
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white70),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: editable ? Colors.grey[800] : Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}
