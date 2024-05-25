import 'dart:convert';
import 'package:http/http.dart' as http;

class GetApiServices {
  final String _baseUrl = 'https://dcbe-212-201-43-42.ngrok-free.app'; // Use localhost

  Future<Map<String, dynamic>?> getIntentFromText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/intent_classifier'), // Your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_input': text}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String answer = data['answer']; // Get the "answer" string

        // Extract JSON data from the "answer" string
        final int startIndex = answer.indexOf('{');
        final int endIndex = answer.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1) {
          final String jsonString = answer.substring(startIndex, endIndex + 1);
          return jsonDecode(jsonString);
        }
        else
        {
          print('Error: Invalid JSON format in response');
          return null;
        }

      }
      else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
  Future<Map<String, dynamic>?> getEntityFromText(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/entity_extraction'), // Your endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_input': text}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final String answer = data['answer']; // Get the "answer" string

        // Extract JSON data from the "answer" string
        final int startIndex = answer.indexOf('{');
        final int endIndex = answer.lastIndexOf('}');
        if (startIndex != -1 && endIndex != -1) {
          final String jsonString = answer.substring(startIndex, endIndex + 1);
          return jsonDecode(jsonString);
        }
        else
        {
          print('Error: Invalid JSON format in response');
          return null;
        }

      }
      else {
        print('Error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}