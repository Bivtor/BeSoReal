import 'package:client/widgets/post.dart';
import 'package:client/login.dart';
import 'package:client/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:client/widgets/header.dart';
import 'package:amplify_core/amplify_core.dart';
import 'package:path_provider/path_provider.dart';

Future<void> downloadFile() async {
  final documentsDir = await getApplicationDocumentsDirectory();
  final filepath = '${documentsDir.path}/example.txt';
  try {
    final result = await Amplify.Storage.downloadFile(
      path: const StoragePath.fromString('public/example.txt'),
      localFile: AWSFile.fromPath(filepath),
    ).result;
    safePrint('Downloaded file is located at: ${result.localFile.path}');
  } on StorageException catch (e) {
    safePrint(e.message);
  }
}

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  bool hasPosted = false;
  var friendsWhoHavePosted = [];

  Future<void> _signOut() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Login(),
            settings:
                RouteSettings(name: const Login().runtimeType.toString())));
    await FirebaseAuth.instance.signOut();
  }

  // Ask firestore if hasPosted is true
  void updatePostedToday() async {
    // Map<String, dynamic> hasPosted = await getUserInfo();
    Map<String, dynamic> friends = await getFriends();
    print('friends');
    print(friends);
    print(friends['username']);

    var posted_friends = [];
    // for (var s in friends['friends']) {
    //   print(s);
    //   posted_friends.add(s);
    // }

    setState(() {
      // hasPosted = hasPosted['hasPosted'];
    });
  }

  @override
  void initState() {
    super.initState();
    updatePostedToday();
    if (hasPosted) {}
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
                    postedToday: hasPosted,
                  ),
                  childCount: 2,
                ),
              ),
            ],
          ),
          if (!hasPosted)
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
