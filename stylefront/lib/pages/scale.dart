import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class Scale extends StatefulWidget {
  @override
  _ScaleState createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  late CameraController _cameraController;
  late List<CameraDescription> _cameras;
  bool _isInitialized = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      _cameraController = CameraController(
        _cameras[_selectedCameraIndex],
        ResolutionPreset.high,
      );
      await _cameraController.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isInitialized = false;
    });
    await _cameraController.dispose();
    setState(() {
      _selectedCameraIndex = _selectedCameraIndex == 0 ? 1 : 0;
    });
    await _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Size Measurement'),
        ),
      body: _isInitialized
          ? CameraPreview(_cameraController)
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _switchCamera,
            child: Icon(Icons.switch_camera),
            heroTag: 'switch_camera',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async {
              try {
                final image = await _cameraController.takePicture();
                print('Image saved to: ${image.path}');
              } catch (e) {
                print('Error capturing image: $e');
              }
            },
            child: Icon(Icons.camera),
            heroTag: 'capture_image',
          ),
        ],
      ),
    );
  }
}
