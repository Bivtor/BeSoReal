import 'dart:ui';
// import 'package:client/feed.dart';
import 'package:client/addFriend.dart';
import 'package:client/login.dart';
import 'package:client/myProfile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:client/feed.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  var first = true;

  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (first) {
      first = false;
      return;
    }

    if (user == null) {
      // go to login page
      print('User is currently signed out!');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const Login(), settings: RouteSettings(name: Login().runtimeType.toString())),
        );
      });
    } else {
      // go to feed page
      print('User is signed in! ${user.email}');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const Feed(), settings: RouteSettings(name: Feed().runtimeType.toString())),
        );
      });
    }
  });

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      routes: {
        '/addFriend': (context) => AddFriend(),
        '/myprofile': (context) => MyProfile(),
      },
      navigatorKey: navigatorKey,

      // hide debug banner
      debugShowCheckedModeBanner: false,

      // allow scrolling in chrome for debugging
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),

      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Login(),
    );
  }
}
