import 'package:client/api.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({super.key});

  @override
  State<AddFriend> createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final TextEditingController _userNameController = TextEditingController();
  String? _userNameError;
  bool _foundUser = false;
  String _foundUserText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _addFriend(BuildContext context) async {
    // Reset found user message
    setState(() {
      _foundUser = false;
    });
    // Get username
    String username = _userNameController.text.trim();

    if (username.isEmpty) {
      setState(() {
        _userNameError = 'Field Cannot be Blank';
      });
      return;
    }

    Map<String, dynamic> result = await addFriend(username);

    // if we left this page, return
    if (!mounted) return;

    if (result['error'] != null) {
      setState(() {
        _userNameError = result['error'];
      });
    } else {
      setState(() {
        _foundUserText = "Successfully Added $username";
        _foundUser = true;
        _userNameError = null;
      });
    }
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (_foundUser)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _foundUserText,
                    style: const TextStyle(color: Colors.green, fontSize: 16),
                  ),
                ),
              if (_userNameError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _userNameError!,
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              TextField(
                controller: _userNameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Username',
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  prefixIcon: const Icon(Icons.person), // left icon
                  suffixIcon: (_userNameError == null &&
                          _userNameController.text.isNotEmpty)
                      ? const Icon(Icons.check)
                      : null, // right icon
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _addFriend(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  child: const Text('Search!',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16.0),
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
