import 'package:client/login.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
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
    _passwordController2.dispose();
    super.dispose();
  }

  void _signup() {
    // do nothing if there are errors
    if (_emailError != null || _passwordError != null) {
      return;
    }

    // String email = _emailController.text;
    // String password = _passwordController.text;

    // TODO register account with server
  }

  void _login() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
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

      if (password.length < 6) {
        _passwordError = 'Password must be at least 6 characters';
        return;
      }

      // contains at least one uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        _passwordError = 'Password must contain at least one uppercase letter';
        return;
      }

      // contains at least one lowercase letter
      if (!RegExp(r'[a-z]').hasMatch(password)) {
        _passwordError = 'Password must contain at least one lowercase letter';
        return;
      }

      if (_passwordController.text != _passwordController2.text) {
        _passwordError = 'Passwords do not match';
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
                onChanged: (_) => _validatePassword(),
                style: const TextStyle(color: Colors.white),
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
              TextField(
                controller: _passwordController2,
                onChanged: (_) => _validatePassword(),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Repeat Password',
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
                  onPressed: _login,
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
