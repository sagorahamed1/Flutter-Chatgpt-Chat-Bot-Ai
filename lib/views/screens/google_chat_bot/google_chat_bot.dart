import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GoogleChatBot extends StatefulWidget {
  const GoogleChatBot({super.key});

  @override
  State<GoogleChatBot> createState() => _GoogleChatBotState();
}

class _GoogleChatBotState extends State<GoogleChatBot> {
  ChatUser mySelf = ChatUser(id: "1", firstName: "Sagor Ahamed");
  ChatUser bot = ChatUser(id: "2", firstName: "Google");
  List<ChatMessage> allMessages = [];
  List <ChatUser> typing = [];

  getMessage(ChatMessage userMessage) async {
    typing.add(bot);
    allMessages.insert(0, userMessage);
    setState(() {});
    var data = {
      "contents": [
        {
          "parts": [
            {"text": userMessage.text}
          ]
        }
      ]
    };
    await http
        .post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyAwU9yKt5-RwcZaD4ve7oLKbgLg8RRCEy0"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data))
        .then((value) {
      if (value.statusCode == 200) {
        var result = jsonDecode(value.body);
        print(
            "----------------------------------${result["candidates"][0]["content"]["parts"][0]["text"]}");
        print("----------------------------------${result["candidates"]}");
        ChatMessage m1 = ChatMessage(
            text: result["candidates"][0]["content"]["parts"][0]["text"],
            user: bot,
            createdAt: DateTime.now());
        allMessages.insert(0, m1);
      }
    }).catchError((e) => print(e));
    typing.remove(bot);
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashChat(
        typingUsers: typing,
        currentUser: mySelf,
        onSend: (ChatMessage userMessgae) {
          getMessage(userMessgae);
        },
        messages: allMessages,
      ),
    );
  }
}
