import 'package:client/settings.dart';
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
      MaterialPageRoute(builder: (context) => newRoute, settings: RouteSettings(name: newRoute.runtimeType.toString())),
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

    // no buttons on login / signup pages
    leading: ModalRoute.of(context)?.settings.name == 'Login' || ModalRoute.of(context)?.settings.name == 'Signup'  || ModalRoute.of(context)?.settings.name == '/' 
    ? null 

    // add friend button on Feed page
    : ModalRoute.of(context)?.settings.name == 'Feed' 
        ? IconButton(
            icon: const Icon(Icons.people, color: Colors.white),
            onPressed: () {
              // Navigate to Add Friends page
              doPageSwitch(context, AddFriend());
            },
          ) 

    // back button on all other pages
        : IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Back to previous page
              Navigator.pop(context);
            },
          ),

    // show the calendar and profile icons only on the Feed page
    actions: ModalRoute.of(context)?.settings.name == 'Feed' ? [
      IconButton(
        icon: const Icon(Icons.calendar_month, color: Colors.white),
        onPressed: () {
          // Add navigation to the calendar page here
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const CalendarPage()));
        },
      ),
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          doPageSwitch(context, Settings());
        },
      ),
    ] : ModalRoute.of(context)?.settings.name == 'MyProfile' ? 
    [
      IconButton(
        icon: const Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Settings(), settings: RouteSettings(name: Settings().runtimeType.toString())));
        },
      ),
    ] : null,


  );
}
