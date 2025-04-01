import 'dart:developer';
import 'dart:math';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../config.dart';

class GenAiService {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-8b',
    // model: 'gemini-2.5-pro-exp-03-25',
    // model: 'gemini-2.0-flash',
    // model: 'gemini-2.0-flash-lite',
    apiKey: GEMINI_API_KEY,
    generationConfig:
        GenerationConfig(responseMimeType: 'text/plain'),
  );

  static const ensureJson = '''
          Generate a response in JSON format with the following structure:
            {
              "response": "Your AI-generated response here"
            }
            Ensure it is valid JSON.
        ''';

  // Example usage:
  // final genAiService = GenAiService();
  // String notification = await genAiService.generateNotificationText('preparing');
  Future<String> generateNotificationText(String orderStatus) async {
    try {
      final prompt = '''
        Create a fun, playful, and engaging push notification (under 160 characters) 
        for a food delivery app with order status: $orderStatus. 
        Make it exciting and memorable. Don't use emojis in the response.
      ''';

      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      String notification = response.text?.trim() ?? orderStatus;
      if (notification.length > 240) {
        notification = '${notification.substring(0, 237)}...';
      }

      return notification;
    } catch (e) {
      return 'Your order status: $orderStatus';
    }
  }

  List<String> introPrompts = [
    '''Create a short intro for a food delivery app with emojis. Make it fun, engaging and creative text. ''',
    '''Generate a fun, engaging, and highly creative short intro for a food delivery app using emojis. Make it catchy and appetizing! Ensure it feels exciting, mouthwatering, and dynamic. ''',
    '''Create a captivating and delicious intro for a food delivery app with emojis. Make it fun, engaging and creative text. ''',

  ];
  // Example usage:
  // final genAiService = GenAiService();
  // String notification = await genAiService.generateIntro();
  Future<String> generateIntro() async {
    try {
      const language = "Malayalam";
      const addtional = "Give only happy and inviting results. Provide a response in $language plain text and emojis only (under 160 characters) , without JSON formatting or structured output.";
      final prompt = introPrompts[Random().nextInt(introPrompts.length)];

      final content = [Content.text(prompt + addtional)];
      final response = await model.generateContent(content);
      print("Generated Response: ${response.text}");
      String textResponse = response.text?.trim() ?? "";
      if (textResponse.length > 240) {
        textResponse = '${textResponse.substring(0, 237)}...';
      }

      return textResponse.replaceAll(RegExp(r'[\{\}\[\]\"]'), '').replaceAll(RegExp(r'^"|"$'), '');
    } catch (e) {
      print(e.toString());
      return "";
    }
  }
}
