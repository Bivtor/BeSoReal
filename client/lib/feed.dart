import 'package:client/addFriend.dart';
import 'package:client/post.dart';
import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  // TODO get this info from the server
  var postedToday = false;

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
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                title: const DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  child: Text('BeSoReal'),
                ),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.people, color: Colors.white),
                  onPressed: () => {
                    // go to friends page
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddFriend())),
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.calendar_month, color: Colors.white),
                    onPressed: () => {
                      // go to calendar page
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => {
                      // go to settings page
                    },
                  ),
                ],
              ),
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
