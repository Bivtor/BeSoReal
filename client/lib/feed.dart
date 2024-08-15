import 'package:client/addFriend.dart';
import 'package:client/widgets/post.dart';
import 'package:client/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // TODO get this info from the server
  var postedToday = false;

  Future<void> _signOut() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
    await FirebaseAuth.instance.signOut();
  }

  void updatePostedToday(bool value) {
    setState(() {
      postedToday = value;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Header(context),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Post(
                    updatePostedToday: updatePostedToday,
                    postedToday: postedToday,
                  ),
                  childCount: 2,
                ),
              ),
            ],
          ),
          if (!postedToday)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: 100.0,
                  height: 100.0,
                  child: FloatingActionButton(
                    shape: const CircleBorder(
                      side: BorderSide(
                        color: Colors.white,
                        width: 4.0,
                      ),
                    ),
                    onPressed: () {
                      // Add your button action here
                    },
                    backgroundColor: Colors.transparent,
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
