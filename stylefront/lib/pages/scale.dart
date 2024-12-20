import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class Scale extends StatefulWidget {
  const Scale({Key? key}) : super(key: key);

  @override
  _ScaleState createState() => _ScaleState();
}

class _ScaleState extends State<Scale> {
  late CameraController _controller;
  bool _isCameraInitialized = false;
  CameraLensDirection _lensDirection = CameraLensDirection.back;
  TextEditingController _heightController = TextEditingController();
  bool _isCountingDown = false;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  Future<void> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.firstWhere(
          (camera) => camera.lensDirection == _lensDirection);
      _controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await _controller.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void toggleCamera() {
    setState(() {
      _lensDirection = _lensDirection == CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
      _isCameraInitialized = false;
    });
    initializeCamera();
  }

  Future<void> captureAndMeasure() async {
    if (!_controller.value.isInitialized || _controller.value.isTakingPicture) {
      return;
    }

    setState(() {
      _isCountingDown = true;
      _countdown = 5;
    });

    for (int i = 0; i < 5; i++) {
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _countdown--;
      });
    }

    setState(() {
      _isCountingDown = false;
    });

    try {
      final image = await _controller.takePicture();
      final imageBytes = await image.readAsBytes();
      final base64Image = base64Encode(imageBytes);
      final userHeight = _heightController.text;

      final response = await http.post(
        Uri.parse('http://192.168.201.134:8000/api/measurement/live/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'user_height': userHeight,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MeasurementResultPage(data: data),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch measurements.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Size Measurement'),
    ),
    body: Column(
      children: [
        if (_isCameraInitialized)
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: _lensDirection == CameraLensDirection.front
                      ? Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(math.pi),
                          child: CameraPreview(_controller),
                        )
                      : CameraPreview(_controller),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: FloatingActionButton(
                    onPressed: toggleCamera,
                    backgroundColor: Color(0xFF023C45),
                    child: Icon(Icons.cameraswitch,color: Colors.white,),
                  ),
                ),
                if (_isCountingDown)
                  Center(
                    child: Text(
                      '$_countdown',
                      style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          )
        else
          Expanded(child: Center(child: CircularProgressIndicator())),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter your height in cm',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF023C45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: captureAndMeasure,
                  child: Text(
                    'Get Measurement',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}

class MeasurementResultPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const MeasurementResultPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Measurement Results')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Shoulder Width: ${data['shoulder_width_cm']} cm', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Hip Width: ${data['hip_width_cm']} cm', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Height: ${data['height_cm']} cm', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Inseam: ${data['inseam_cm']} cm', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Scaling Factor: ${data['scaling_factor']}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}