import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';
import 'package:client/api.dart';
import 'package:flutter/foundation.dart';

class AccountSettings extends StatefulWidget {
  const AccountSettings({super.key});

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
    fetchData();
    super.initState();
  }

  void fetchData() async {
    Map<String, dynamic> result = await getUserInfo();

    if (!mounted) return;
    if (result['error'] != null) return;

    setState(() {
      username = result['username'];
      displayName = result['displayName'];
      email = result['email'];
      photoURL = result['photoURL'] ?? '';
    });
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
                    backgroundImage: photoURL != '' ? NetworkImage(photoURL) : null,
                    backgroundColor: Colors.grey[800],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () async {

                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                        if (result == null) return;

                        if (kIsWeb) {
                          // Web platform: use `bytes`

                          // convert to base64
                          Uint8List? fileBytes = result.files.first.bytes;
                          if (fileBytes == null) return;
                          String img = base64Encode(fileBytes);
                          
                          // Upload to AWS
                          Map<String, dynamic> uploadResult = await uploadImage(img, 'profile');
                          if (!mounted) return;
                          if (uploadResult['error'] != null) return;

                          setState(() {
                            photoURL = uploadResult['photoURL'];
                          });

                        } else {
                          // Non-web platforms (Mobile/Desktop): use `path`

                          // convert to base64
                          String? filePath = result.files.single.path;
                          if (filePath == null) return;
                          File file = File(filePath);
                          List<int> imageBytes = file.readAsBytesSync();
                          String img = base64Encode(imageBytes);

                          // Upload to AWS
                          Map<String, dynamic> uploadResult = await uploadImage(img, 'profile');
                          if (!mounted) return;
                          if (uploadResult['error'] != null) return;

                          setState(() {
                            photoURL = uploadResult['photoURL'];
                          });
                        }

                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Display Name Text Field
            _buildTextField(
              controller: _displayNameController,
              labelText: 'Display Name',
              hintText: 'Enter your display name',
              defaultValue: displayName,
            ),
            const SizedBox(height: 16),

            // Username Text Field
            _buildTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter your username',
              defaultValue: username,
            ),
            const SizedBox(height: 24),

            // Email Text Field
            _buildTextField(
              controller: _emailController,
              labelText: 'Email',
              editable: false,
              defaultValue: email,
            ),
            const SizedBox(height: 24),

            // Save Button
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {

                    if (FirebaseAuth.instance.currentUser?.uid == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User not logged in'),
                        ),
                      );
                      return;
                    }

                    // firebase save
                    Map<String, dynamic> result = await updateAccount(_usernameController.text, _displayNameController.text);

                    if (result['success'] != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account settings saved'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: const Color.fromARGB(255, 128, 20, 20),
                          content: Text(result['error']),
                        ),
                      );
                    }

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
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: editable ? Colors.grey[800] : Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      ),
    );
  }
}
