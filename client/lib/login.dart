import 'package:client/feed.dart';
import 'package:client/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login(BuildContext context) async {
    // Retrieve email and password from controllers
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    // Check for validation errors
    if (_emailError != null || _passwordError != null) {
      // Optionally show an error message to the user
      print('Validation errors present.');
      return;
    }
    if (email.length == 0 || password.length == 0) {
      print('Blank password or email');
      return;
    }

    // TODO: Validate email and password format before proceeding

    try {
      // Attempt to sign in with Firebase Auth
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      // Check if user is not null and print the UID
      if (user != null) {
        print(user.uid);
        // Navigate to Feed page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Feed()),
        );
      } else {
        // Handle the case where user is null
        print('User sign-in failed.');
      }
    } catch (e) {
      // Handle errors such as invalid credentials
      print('Error occurred: $e');
      print(e);
      // Optionally show an error message to the user
    }
  }

  void _signup() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Signup()));
  }

  void _validateEmail() {
    String email = _emailController.text;
    setState(() {
      if (email.isEmpty) {
        _emailError = 'Email is required';
        return;
      }

      final bool emailValid = RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+\.[a-zA-Z]{2,}$")
          .hasMatch(email);
      if (!emailValid) {
        _emailError = 'Email is invalid';
        return;
      }

      _emailError = null;
    });
  }

  void _validatePassword() {
    String password = _passwordController.text;
    setState(() {
      if (password.isEmpty) {
        _passwordError = 'Password is required';
        return;
      }

      _passwordError = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_emailError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _emailError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              TextField(
                controller: _emailController,
                onChanged: (_) => _validateEmail(),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.person), // left icon
                  suffixIcon:
                      (_emailError == null && _emailController.text.isNotEmpty)
                          ? const Icon(Icons.check)
                          : null, // right icon
                ),
              ),
              const SizedBox(height: 16.0),
              if (_passwordError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _passwordError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                onChanged: (_) => _validatePassword(),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.lock), // left icon
                  suffixIcon: (_passwordError == null &&
                          _passwordController.text.isNotEmpty)
                      ? const Icon(Icons.check)
                      : null, // right icon
                ),
              ),
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text('Login',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signup,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text('Signup',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: const Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [],
      ),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width,
    );
  }
}
