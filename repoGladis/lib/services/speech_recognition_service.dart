import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:repo/views/Authentification/login_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' ;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts=FlutterTts();

  bool isListening = false;
  String _recognizedText = "";


  // Initialize the speech recognizer
  Future<void> initialize() async {
    if (!await _speechToText.initialize()) {
      print('Speech Recognition not available');
      return;
    }

    var permissionStatus = await Permission.microphone.request();
    if (permissionStatus != PermissionStatus.granted) {
      print('Microphone permission denied');
      // Handle permission denial gracefully
    }
  }

  // Start listening for voice commands
  void startListening(Function(String) onResult) async {
    if (_speechToText.isAvailable) {
      await _speechToText.listen(onResult: _onSpeechResult);
      isListening = true;
      _recognizedText = ''; // Clear previous text
      onResult(_recognizedText); // Update UI with empty text
    }
    else
    {
      print('Speech Recognition not available');
      // Handle the error, perhaps display a message to the user
    }
  }

  // Stop listening
  void stopListening() {
    _speechToText.stop();
    isListening = false;
  }

  // Internal method to handle speech recognition results
  void _onSpeechResult(SpeechRecognitionResult result)
  {
    _recognizedText = result.recognizedWords;
    if (!_speechToText.isListening) {
      // Process command when speech is finished
      _processCommand(_recognizedText);
    }
  }
 Future _speak(String text) async
 {
   await _flutterTts.setLanguage('en-US');
   await _flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
   await _flutterTts.speak(text);

 }
  // Process recognized commands
  void _processCommand(String command) {
    // Example command handling:
    if (command.toLowerCase().contains('login')) {
      _speak("I am opening the login page");
      Get.to(const Login());
      print('User asked for today\'s events');
      // Get today's events from the calendar data service
    } else if (command.toLowerCase().contains('tomorrow')) {
      print('User asked for tomorrow\'s events');
      // Get tomorrow's events from the calendar data service
    } else if (command.toLowerCase().contains('create appointment')) {
      print('User wants to create an appointment');
      // Initiate appointment creation flow
    } else {
      print('Unknown command: $command');
    }
  }
}