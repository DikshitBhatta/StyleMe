import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _cameraController.initialize();
      setState(() {
        _isInitialized = true;
      });
      _streamLiveFeed();
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _switchCamera() async {
    setState(() {
      _isInitialized = false;
    });
    await _cameraController.dispose();
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _initializeCamera();
  }

  void _streamLiveFeed() {
    _cameraController.startImageStream((CameraImage image) async {
      try {
        final bytes = image.planes[0].bytes; 
        await _sendToBackend(Uint8List.fromList(bytes));
      } catch (e) {
        print('Error streaming live feed: $e');
      }
    });
  }

  Future<void> _sendToBackend(Uint8List frameBytes) async {
    try {
      final uri = Uri.parse('http://127.0.0.1:8000/api/measurements/live/');
      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        http.MultipartFile.fromBytes(
          'frame',
          frameBytes,
          filename: 'frame.jpg',
        ),
      );
      final response = await request.send();
      if (response.statusCode == 200) {
        print('Frame sent successfully');
      } else {
        print('Failed to send frame: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending frame to backend: $e');
    }
  }

  @override
  void dispose() {
    _cameraController.stopImageStream();
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
      floatingActionButton: FloatingActionButton(
        onPressed: _switchCamera,
        child: Icon(Icons.switch_camera),
      ),
    );
  }
}
