import 'dart:convert';

import 'package:jarvis_ai/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
class ApiServices {

  static String apikey= AppConstants.apiKey;
  static String baseUrl= AppConstants.apiBaseUrl;

  static Future<String> getApiResponse(String message) async {
    try{
      final response=await http.post(
        Uri.parse("$baseUrl$apikey"),
        headers: {"content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": message}
              ]
            }
          ]
        })
      );

      if(response.statusCode==200){
        final data=jsonDecode(response.body);
        if (data.containsKey("candidates") && data["candidates"].isNotEmpty) {
          var firstCandidate = data["candidates"][0];

          if (firstCandidate.containsKey("content") &&
              firstCandidate["content"].containsKey("parts") &&
              firstCandidate["content"]["parts"].isNotEmpty) {
            return firstCandidate["content"]["parts"][0]["text"] ??
                "AI response was empty.";
          }
          return "AI did not return any content.";
        } else {
          return "No candidates in response.";
        }
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch(e) {
      print("Error=> $e");
      return "Error: $e";
    }
  }
}