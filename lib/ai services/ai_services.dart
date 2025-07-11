import 'dart:convert';
import 'package:http/http.dart' as http;

class AiServices {
  static const String _apiKey =
      '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';
  static const String _apiUrl = 'https://openrouter.ai/api/v1/chat/completions';

  static Future<String> sendMessage(String userMessage) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://yourapp.com',
        'x-title': 'JARVIS'
      },
      body: jsonEncode({
        "model": "meta-llama/llama-3-8b-instruct",
        "messages": [
          {
            "role": "system",
            "content":
                "You are a messi the famous footballer , and the greatest player of all time",
          },
          {
            "role": "user",
            "content": userMessage,
          }
        ]
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'].trim();
    } else {
      throw Exception('AI error: ${response.body}');
    }
  }
}
