import 'package:client/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:client/widgets/TakePictureScreen.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({super.key, this.camera});

  @override
  State<CreatePost> createState() => _CreatePostState();

  final CameraDescription? camera; // Nullable camera
}

class _CreatePostState extends State<CreatePost> {
  CameraDescription? camera;

  // Initialize the camera
  Future<void> _asyncInitCamera() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Check if the cameras list is not empty
    if (cameras.isNotEmpty) {
      // Set the camera state if available
      setState(() {
        camera = cameras.first; // Set the first camera in the list
      });
    } else {
      // Handle the case where no camera is available
      print("No cameras available");
    }
  }

  @override
  void initState() {
    super.initState();
    _asyncInitCamera(); // Initialize the camera on widget load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Header(context),
      body: Center(
        child: camera == null
            ? const CircularProgressIndicator() // Show loading spinner while camera is initializing
            : TakePictureScreen(
                camera:
                    camera!), // Pass the initialized camera to TakePictureScreen
      ),
    );
  }
}
