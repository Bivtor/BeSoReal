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
  bool loadingFriends = true;

  List<dynamic> _friends = [];
  List<dynamic> _friendRequests = [];

  @override
  void initState() {
    loadFriends();
    super.initState();
  }

  void loadFriends() async {
    Map<String, dynamic> friends = await getFriends();

    if (friends['error'] != null) {
      print(friends['error']);
      return;
    }

    setState(() {
      _friends = friends['friends'];
      _friendRequests = friends['friendRequests'];
      print(_friends);
      print(_friendRequests);
      loadingFriends = false;
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  Future<void> _removeFriend(BuildContext context, String targetUserID) async {
    Map<String, dynamic> result = await removeFriend(targetUserID);
    if (!mounted) return;

    if (result['error'] == null) {
      print(result['error']);
      return;
    }

    loadFriends();
  }

  Future<void> _addFriend(BuildContext context, String targetUsername) async {
    // Reset found user message
    setState(() {
      _foundUser = false;
    });

    // Get username
    // String username = _userNameController.text.trim();

    // if (username.isEmpty) {
    //   setState(() {
    //     _userNameError = 'Field Cannot be Blank';
    //   });
    //   return;
    // }

    Map<String, dynamic> result = await addFriend(targetUsername);

    // if we left this page, return
    if (!mounted) return;

    if (result['error'] == null) {
      setState(() {
        _userNameError = result['error'];
      });
      return;
    }

    if (result['success']['message'] == "Friend request sent") {
      setState(() {
        _foundUserText = "Friend request sent to $targetUsername";
        _foundUser = true;
        _userNameError = null;
      });
    } else {
      setState(() {
        _foundUserText = "Successfully Added $targetUsername";
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
      body: Column(
        children: [
          // "Friends" header aligned to the left
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Friends',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          // Friends List
          if (!loadingFriends)
            Expanded(
              child: _friends.isNotEmpty
                  ? ListView.builder(
                      itemCount: _friends.length,
                      itemBuilder: (context, index) {
                        var friend = _friends[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: friend['photoURL'] != ""
                                ? NetworkImage(friend['photoURL'])
                                : null,
                          ),
                          title: Text(friend['displayName'],
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(friend['username'],
                              style: const TextStyle(color: Colors.white70)),
                          trailing: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            onPressed: () {
                              // Logic to remove friend
                              removeFriend(friend['username']);
                            },
                            child: const Text('Remove Friend',
                                style: TextStyle(color: Colors.white)),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No friends found.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
          if (loadingFriends)
            Center(
              child: CircularProgressIndicator(),
            ),

          // Add a horizontal line (Divider)
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),

          // "Friend Requests" Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Friend Requests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          // Friend Requests List
          if (!loadingFriends)
            _friendRequests.isNotEmpty
                ? ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _friendRequests.length,
                      itemBuilder: (context, index) {
                        var request = _friendRequests[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: request['photoURL'] != ""
                                ? NetworkImage(request['photoURL'])
                                : null,
                          ),
                          title: Text(request['displayName'],
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(request['username'],
                              style: const TextStyle(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.green),
                                ),
                                onPressed: () {
                                  _addFriend(context, request['username']);
                                },
                                child: const Text('Add Friend',
                                    style: TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey),
                                ),
                                onPressed: () {
                                  _removeFriend(context, request['username']);
                                },
                                child: const Text('Ignore',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : const Center(
                    child: Text(
                      'No friend requests.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

          if (loadingFriends)
            Center(
              child: CircularProgressIndicator(),
            ),

          // Add a horizontal line (Divider)
          const Divider(
            color: Colors.white,
            thickness: 1,
          ),

          // "Send Friend Request" Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: const Text(
              'Send Friend Request',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
          ),

          // Add user input for adding new friends
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: (_userNameError == null &&
                            _userNameController.text.isNotEmpty)
                        ? const Icon(Icons.check)
                        : null,
                  ),
                ),
                const SizedBox(height: 16.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () =>
                        _addFriend(context, _userNameController.text),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
