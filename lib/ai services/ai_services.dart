import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AiServices with ChangeNotifier {
  static const String _apiKey =
      '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';
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';
  static Future<String> sendMessage(
    String userMessage, {
    String? systemPrompt,
  }) async {
    /*

    // create the required headers of the AI

    */
    Map<String, String> getHeaders() => {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
      'HTTP-Referer': 'https://yourapp.com',
      'x-title': 'JARVIS',
    };
    /*


    // format the request body according to the AI specs

    who are you
    */
    String getRequestBody(String content) => jsonEncode({
      "model": "meta-llama/llama-3-8b-instruct",
      "messages": [
        {
          "role": "system",
          "content":
              systemPrompt ??
              "You are a helpful AI assistant that answers clearly and politely.",
        },
        {"role": "user", "content": userMessage},
      ],
      "temperature": 0.7,
      "max_tokens": 120,
      "top_p": 0.9,
      "stop": ["User:", "You:"],
    });

    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: getHeaders(),
      body: getRequestBody(userMessage),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('AI error: ${response.body}');
    }
  }
}
