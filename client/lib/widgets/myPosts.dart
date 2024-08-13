import 'package:flutter/material.dart';

class AllMyPosts extends StatefulWidget {
  const AllMyPosts({super.key});

  @override
  State<AllMyPosts> createState() => AllMyPostsState();
}

class AllMyPostsState extends State<AllMyPosts> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 10.0, // gap between adjacent chips
          runSpacing: 10.0, // gap between lines
          children: [
            Chip(
              label: Text('Chip 1'),
            ),
            Chip(
              label: Text('Chip 2'),
            ),
            Chip(
              label: Text('Chip 3'),
            ),
            Chip(
              label: Text('Chip 4'),
            ),
            Chip(
              label: Text('Chip 5'),
            ),
            Chip(
              label: Text('Chip 6'),
            ),
            Chip(
              label: Text('Chip 7'),
            ),
          ],
        ),
      ),
    );
  }
}
