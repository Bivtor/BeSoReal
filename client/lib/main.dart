import 'dart:ui';
// import 'package:client/feed.dart';
import 'package:client/addFriend.dart';
import 'package:client/login.dart';
import 'package:client/myProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:client/feed.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_authenticator/amplify_authenticator.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
//import 'amplify_outputs.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    //await _configureAmplify();
    runApp(const MyApp());
  } on AmplifyException catch (e) {
    runApp(Text("Error configuring Amplify: ${e.message}"));
  }

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
          MaterialPageRoute(
              builder: (context) => const Login(),
              settings: RouteSettings(name: const Login().runtimeType.toString())),
        );
      });
    } else {
      // go to feed page
      print('User is signed in! ${user.email}');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
              builder: (context) => const Feed(),
              settings: RouteSettings(name: const Feed().runtimeType.toString())),
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
        '/addFriend': (context) => const AddFriend(),
        '/myprofile': (context) => const MyProfile(),
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
