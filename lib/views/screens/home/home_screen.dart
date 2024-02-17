import 'package:flutter/material.dart';
import 'package:flutter_ai/views/screens/Ai_Text/ai_text.dart';
import 'package:flutter_ai/views/screens/google_chat_bot/google_chat_bot.dart';
import 'package:flutter_ai/views/screens/google_recorder/google_recorder.dart';
import 'package:get/get.dart';

import '../Ai_With_Image/ai_with_image.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          TextButton(onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GoogleRecorder() ));
          },child: Text("Ai with voice")),



          TextButton(onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AiAssistant() ));
          },child: Text("Ai with Image")),



          TextButton(onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AiWithText() ));
          },child: Text("Text")),


          TextButton(onPressed : (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>GoogleChatBot() ));
          },child: Text("Google chat bot")),
        ],
      ),
    );
  }
}
