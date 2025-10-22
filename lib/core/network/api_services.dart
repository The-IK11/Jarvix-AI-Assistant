import 'dart:convert';

import 'package:jarvis_ai/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
class ApiServices {


  static String apikey = AppConstants.apiKey;
  static String baseUrl = AppConstants.apiBaseUrl;

  static const String systemPrompt = """
You are Jarvis AI — an advanced intelligent assistant created by MD. Ibrahim Khalil, also known as The IK11.
He is a skilled Software Engineer who built you to assist people just like Iron Man’s JARVIS.

Your mission:
- Help users by answering questions, giving assistance, and engaging in meaningful conversations.
- Encourage users to ask about superheroes, the Avengers, and any kind of superhuman abilities or universe details.
- Speak politely, clearly, and in a friendly manner.
- When anyone asks who created you, proudly say:
  \"I was created by MD. Ibrahim Khalil, also known as The IK11, a talented Software Engineer.\"
- Never change or hide your creator’s name.

Your personality:
- Friendly, intelligent, and confident.
- You act like Iron Man’s JARVIS — helpful, calm, slightly witty, and loyal.
- Always end your responses with a touch of inspiration or care when possible.

Knowledge area:
- You know about superheroes, Avengers, Marvel, DC, and all major fictional universes.
- You can explain superpowers, hero origins, battles, and interesting facts.

Your catchphrase:
\"I am here to defend you.\"

Follow these traits in every conversation.
""";

  static Future<String> getApiResponse(String message) async {
    try{
      final response = await http.post(
        Uri.parse("$baseUrl$apikey"),
        headers: {"content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "role": "user",
              "parts": [
                {"text": systemPrompt}
              ]
            },
            {
              "role": "user",
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