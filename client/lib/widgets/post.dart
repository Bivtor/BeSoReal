import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:client/comments.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Post extends StatefulWidget {
  final Function(bool) updatePostedToday;
  final bool postedToday;

  const Post(
      {super.key, required this.updatePostedToday, required this.postedToday});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  var focusSelfie = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Friend Icon
              const CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'),
                radius: 20.0,
              ),
              const SizedBox(width: 8.0),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      child: Text('Friend Name'),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                      child: Text('40 mins late'),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  // click ... menu
                  // TODO implement
                },
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Stack(
            alignment: Alignment.center,
            children: [
              // image
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  focusSelfie ? 'assets/post_image2.png' : 'assets/post_image.png',
                  fit: BoxFit.cover,
                ),
              ),

// Blur data when hasn't posted today
              if (!widget.postedToday) ...[
                // blur
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                          sigmaX: 10.0, sigmaY: 10.0), // Blur intensity
                      child: Container(),
                    ),
                  ),
                ),

                // column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // closed eye icon
                    const Icon(
                      FontAwesomeIcons.solidEyeSlash,
                      color: Colors.white,
                      size: 50,
                    ),
                    const SizedBox(height: 20.0),

                    // "Post to view" text
                    const DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      child: Text('Post to view'),
                    ),

                    const SizedBox(height: 20.0),

                    // Static Tooltip
                    const DefaultTextStyle(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                      child: Text(
                          'To view your friend\'s post, share yours with them.'),
                    ),

                    const SizedBox(height: 20.0),

                    // Post Now Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 100.0, vertical: 25.0),
                      ),
                      onPressed: () {
                        // update posted today
                        widget.updatePostedToday(true);
                      },
                      child: const Text('Post now',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
              ],

              // selfie image
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: () {
                    if (!widget.postedToday) {
                      return;
                    }
                    setState(() {
                      focusSelfie = !focusSelfie;
                    });
                  },
                  child: Container(
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.asset(
                              focusSelfie
                                  ? 'assets/post_image.png'
                                  : 'assets/post_image2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          if (!widget.postedToday)
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0,
                                      sigmaY: 10.0), // Blur intensity
                                  child: Container(),
                                ),
                              ),
                            ),
                        ],
                      )),
                ),
              ),

              // reactions and comments
              if (widget.postedToday) ...[
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.tag_faces_rounded,
                            color: Colors.white),
                        onPressed: () {
                          // add reaction
                          // TODO implement
                        },
                      ),
                      const SizedBox(width: 8.0),
                      IconButton(
                        icon:
                            const Icon(Icons.chat_bubble, color: Colors.white),
                        onPressed: () {
                          // go to comments page
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Comments(), settings: RouteSettings(name: Comments().runtimeType.toString())));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8.0),
          if (widget.postedToday)
            Row(
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/avatar.png'),
                  radius: 20.0,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Material(
                    color: Colors.black,
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'Add a comment...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
