import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:client/api.dart';
import 'dart:convert';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  var showLoadingBar = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<void> _asyncConvertAndUpload(XFile image) async {
    // TODO Freeze screen and do image upload to S3

    final _bytes = await image.readAsBytes(); // Convert to bytes
    final _base64string = base64Encode(_bytes); // Convert to base64

    // Enable loading animation
    setState(() {
      showLoadingBar = true;
    });

    // Call S3 upload from api.dart
    Map<String, dynamic> result = await uploadImage(_base64string, 'photo1'); //

    // TODO Set photoURL as my firebase photoURL ?
    // TODO Prevent double button clicks

    // Disable loading animation
    setState(() {
      showLoadingBar = false;
    });

    // Go back to Home
    Navigator.popUntil(
      context,
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                final image = await _controller.takePicture();
                _asyncConvertAndUpload(
                    image); // Convert to bytes and upload to server

                if (!context.mounted) return;
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
        ),
        if (showLoadingBar)
          Positioned.fill(
            child: Align(
                alignment: Alignment.center, // Centers the widget
                child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
