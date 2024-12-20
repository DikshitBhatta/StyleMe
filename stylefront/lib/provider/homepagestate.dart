import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomepageState extends ChangeNotifier {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _voiceInput = "";

  HomepageState() {
    _speech = stt.SpeechToText();
  }

  bool get isListening => _isListening;
  String get voiceInput => _voiceInput;

  void startListening(Function(String) onSearchSubmitted) async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      _isListening = true;
      notifyListeners();
      _speech.listen(onResult: (result) {
        _voiceInput = result.recognizedWords;
        notifyListeners();
        onSearchSubmitted(_voiceInput);
        stopListening(); // Stop listening after the search is submitted
      });
    }
  }

  void stopListening() {
    _isListening = false;
    _speech.stop();
    notifyListeners();
  }
}
