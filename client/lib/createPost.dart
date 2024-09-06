import 'package:client/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

// var status = await Permission.camera.status;
// if (status.isDenied) {
//   // We haven't asked for permission yet or the permission has been denied before, but not permanently.
// }

// // You can also directly ask permission about its status.
// if (await Permission.location.isRestricted) {
//   // The OS restricts access, for example, because of parental controls.

// }

class CreatePost extends StatefulWidget {
  const CreatePost({super.key});

  @override
  State<CreatePost> createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.veryHigh,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _captureImage() async {
    try {
      await _initializeControllerFuture;

      final image = await _controller.takePicture();

      // You can now do something with the image, like display it or save it
      print('Image captured: ${image.path}');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: Header(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Create a post",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              Padding(
                  padding: const EdgeInsets.all(1),
                  child: FutureBuilder(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            children: [
                              Expanded(
                                child: CameraPreview(_controller),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: _captureImage,
                                  child: const Text('Capture Image'),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}
