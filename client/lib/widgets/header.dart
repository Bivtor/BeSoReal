import 'package:client/feed.dart';
import 'package:flutter/material.dart';
import 'package:client/myProfile.dart';
import 'package:client/addFriend.dart';

AppBar Header(context) {
  return AppBar(
    backgroundColor: Colors.black,
    // elevation: 0, // Removes the shadow below the AppBar
    title: GestureDetector(
      onTap: () {
        // Goto Home feed when you tap the title
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Feed()));
      },
      child: const DefaultTextStyle(
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        child: Text('BeSoReal'),
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.people, color: Colors.white),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddFriend()),
        );
      },
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.calendar_month, color: Colors.white),
        onPressed: () {
          // Add navigation to the calendar page here
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPage()));
        },
      ),
      IconButton(
        icon: const Icon(Icons.person, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MyProfile()),
          );
        },
      ),
    ],
  );
}
