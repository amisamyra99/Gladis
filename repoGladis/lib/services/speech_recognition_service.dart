import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:repo/models/appointment.dart';
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



      // 2. Handle intents
        switch (userIntent) {
          case 'create_appointment':
            DateFormat format = DateFormat("MM/dd/yyyy");
            DateFormat format2 = DateFormat("MM/dd/yyyy HH:mm");

            String dateFromApi = apiResponseEntity!['date'] ?? '';
            String startTimeFromApi = apiResponseEntity['from'] ?? '';
            String endTimeFromApi = apiResponseEntity['to'] ?? '';
            DateTime? date= format.parse(dateFromApi);
            String title = apiResponseEntity['reason'] ??"Event";

            DateTime? startTime= format2.parse(dateFromApi+' '+startTimeFromApi);
            DateTime? endTime = format2.parse(dateFromApi+' '+endTimeFromApi);
            // String? location= apiResponseEntity?['date'];
            if (title != null) {
              print(title);

              //process API input and ask futher question
              _dataService.createAppointment(
                  Appointment(title: title, startTime: startTime,endTime: endTime));
              _speak('so your apointement has been created for');
            }
            else {
              print('User wants to create an appointment');
              _speak(
                  'What is the date, time and the reason for the appointment?');
            }

            break;
          case 'modify_appointment':
            print('User wants to modify an appointment');
            _speak('What appointment you want to modify ?');

            break;
          case 'delete_appointment':
            print('User wants to delete an appointment');
            _speak('What appointment you want to delete?');
            break;
          case 'check_meeting':
            print('User wants to check meetings');
            _speak('What day you want to check ?');

            break;

          case 'query':
            break;

          case 'unknown':
            _speak("you have to configurate a command fro that ");
            print('Unknown command: $command');
            break;

          default:
            _speak('Sorry, I didn\'t understand. Can you try again?');
            break;
        }
    }
    else {
      _speak('Please try to check your internet connexion for ?');
      print('API request failed or returned null');
    }

  }
}
void  processApiOutput(String title, String  starTime, String endTime,String location)
{
// specific word like
// tomorow , in two number of days , //weedays

//time
//pm or am

//title confirmation
//before create appointment

// possible to create reminder event

// actual date issue
//for exemple if no date specify consider today and the actual year more importantly
}


void processQueryApi(String title,String  starTime, String endTime,String location,String category)
{
// what==> Category or title  and when ?
// be general an only focus on date and \\ list of meetings \\ check avalaibility\\


}