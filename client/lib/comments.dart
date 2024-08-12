import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  const Comments({super.key});

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          Positioned(
            left: 16.0,
            top: 16.0,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                // click back
                // navigate back
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            right: 16.0,
            top: 16.0,
            child: IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {
                // click settings button
              },
            ),
          ),
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                child: Text('BeSoReal'),
              ),
            ),
          ),

          // scrollable feed
          // ListView(
          //   children: const [
              

          //   ],
          // ),

          

        ],
      ),
    );
  }
}
