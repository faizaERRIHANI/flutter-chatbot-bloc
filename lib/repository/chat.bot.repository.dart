import 'package:chat_bot_app/model/chat.bot.model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatBotRepository {
  Future<Message> askLargeLangueModelGPT(String query) async {
    var url = "http://localhost:11434/api/chat";

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    var prompt = {
      "model": "tinyllama",
      "messages": [
        {"role": "user", "content": query}
      ],
      "stream": false
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(prompt),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> result = jsonDecode(response.body);
        Message message = Message(
          message: result['message']['content'],
          type: "assistant",
        );
        return message;
      } else {
        throw Exception("Erreur API: ${response.statusCode}");
      }
    } catch (err) {
      rethrow;
    }
  }
}
