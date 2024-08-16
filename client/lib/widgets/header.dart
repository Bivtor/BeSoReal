import 'package:flutter/material.dart';
import 'package:client/myProfile.dart';
import 'package:client/addFriend.dart';

void doPageSwitch(context, newRoute) {
  if (ModalRoute.of(context)?.settings.name ==
      newRoute.runtimeType.toString()) {
    // The current route is the same as the new route, so do nothing
  } else {
    // Navigate to the new route
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => newRoute),
    );
  }
}

AppBar Header(context) {
  return AppBar(
    backgroundColor: Colors.black,
    // elevation: 0, // Removes the shadow below the AppBar
    title: GestureDetector(
      onTap: () {
        // Goto Home feed when you tap the title
        Navigator.popUntil(
          context,
          (route) => route.isFirst,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: const DefaultTextStyle(
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          child: Text('BeSoReal'),
        ),
      ),
    ),
    centerTitle: true,
    leading: IconButton(
      icon: const Icon(Icons.people, color: Colors.white),
      onPressed: () {
        // Navigate to Add Friends page
        doPageSwitch(context, AddFriend());
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const AddFriend()),
        // );
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
