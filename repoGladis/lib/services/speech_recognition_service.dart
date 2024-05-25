import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:repo/models/appointment_customized.dart';
import 'package:repo/services/calendar_data_service.dart';
import 'package:repo/views/Authentification/login_screen.dart';
import 'package:speech_to_text/speech_to_text.dart' ;
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:intl/intl.dart';
import 'apiService.dart';

class SpeechRecognitionService {
  //final --"This variable can only be assigned a value once."
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts=FlutterTts();
  bool isListening = false;
  String _recognizedText = "";
  final GetApiServices _apiService = GetApiServices(); // Create an instance of your service
  final _dataService = CalendarDataService();
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
   await _flutterTts.setSpeechRate(0.4); // Adjust speech rate as needed
   await _flutterTts.speak(text);

 }
  // Process recognized commands
  void _processCommand(String command) async{

    // 1. Make API call to get the intent
    Map<String, dynamic>? apiResponse = await _apiService.getIntentFromText(command);
    Map<String, dynamic>? apiResponseEntity = await _apiService.getEntityFromText(command);


    if (apiResponse != null) {
      String? userIntent = apiResponse['user_intent'];

      DateFormat format = DateFormat("MM/dd/yyyy");

      String dateFromApi = apiResponseEntity!['date'] ?? '';
      DateTime? date= format.parse(dateFromApi);
      String title = apiResponseEntity['reason'] ??"Event";
      //DateTime? startTime= (apiResponseEntity?['from'].isNotEmpty) ? DateTime.parse(dateFromApi);
      //DateTime? endTime = apiResponseEntity?['to'];
     // String? location= apiResponseEntity?['date'];



      print('***********************');
      print(userIntent);
      // 2. Handle intents
      if (userIntent == 'create_appointment') {

        if (title!=null){
          print(title);
          _dataService.createAppointment(Appointment(title:title,startTime:date));
          _speak('so your apointement has been created for');
        }
        else {
          print('User wants to create an appointment');
          _speak('What is the date, time and the reason for the appointment?');
        }
        // Initiate appointment creation flow
      } else if (userIntent == 'delete_appointment') {
        print('User wants to delete an appointment');
        _speak('What appointment you want to delete?');
        // Initiate appointment deletion flow
      } else if (userIntent == 'modify_appointment') {
        print('User wants to modify an appointment');
        _speak('What appointment you want to modify ?');
        // Initiate appointment modification flow
      } else if (userIntent == 'check_meeting') {
        print('User wants to check meetings');
        _speak('What day you want to check ?');
      }
      else if (command.toLowerCase().contains('login')) {
        _speak("I am opening the login page");
        Get.to(const Login());
        print('User asked for today\'s events');
        // Get today's events from the calendar data service
      } else if (command.toLowerCase().contains('tomorrow')) {
        print('User asked for tomorrow\'s events');
        _speak("I do not have information for tomorow event");
        // Get tomorrow's events from the calendar data service
      }
      else if (command.toLowerCase().contains('create appointment')) {
        print('User wants to create an appointment');
        // Initiate appointment creation flow
      }
      else {
        _speak("you have to configurate a command fro that ");
        print('Unknown command: $command');
      }
    }
    else {
      _speak('Sorry, I didn\'t understand. Can you try again?');
      print('API request failed or returned null');
    }
  }
}
