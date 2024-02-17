import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class GoogleRecorder extends StatefulWidget {
  const GoogleRecorder({super.key});

  @override
  State<GoogleRecorder> createState() => _GoogleRecorderState();
}

class _GoogleRecorderState extends State<GoogleRecorder> {
  bool isSpeak = false;
  TextEditingController textController = TextEditingController();
  final SpeechToText speechToTextinstance = SpeechToText();
  String recoudedAudioString = "";

  ///--------------------initalize speech to text--------------------------
  void InitializeSpeechToText() async {
    await speechToTextinstance.initialize();
    setState(() {});
  }

  void StartLisiningNow() async {
    FocusScope.of(context).unfocus();
    await speechToTextinstance.listen(onResult: onSpeechToResult);
    setState(() {});
  }

  StopLisininNow() async {
    await speechToTextinstance.stop();
    setState(() {});
  }

  void onSpeechToResult(SpeechRecognitionResult recognitionResult) {
    recoudedAudioString = recognitionResult.recognizedWords;
    print("------------------------------$recoudedAudioString");
    setState(() {
      textController.text = recoudedAudioString;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitializeSpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text("Open Ai"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.message)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.image))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          isSpeak ?  Speak(text) : StopSeak();
          setState(() {
            isSpeak = !isSpeak;
          });
        },
        child: isSpeak ? Image.asset("assets/images/sound.png") : Image.asset("assets/images/mute.png"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
          child: Column(
            children: [
              ///--------------------------------recording image---------------------------------->
              IconButton(
                  onPressed: () {
                    speechToTextinstance.isListening
                        ? StopLisininNow()
                        : StartLisiningNow();
                  },
                  icon: speechToTextinstance.isListening
                      ? Center(
                          child: LoadingAnimationWidget.beat(
                              color: speechToTextinstance.isListening
                                  ? Colors.deepPurpleAccent
                                  : Colors.white60,
                              size: 120),
                        )
                      : Image.asset("assets/images/recording.png")),

              const SizedBox(
                height: 50,
              ),

              ///-----------------------text field_---------------------------->
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: InputDecoration(
                          hintText: "How can i help you?",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8))),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      StopLisininNow();
                      getGemini(textController.text);
                    },
                    child: AnimatedContainer(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          shape: BoxShape.rectangle,
                          color: Colors.deepPurpleAccent),
                      duration: const Duration(microseconds: 1000),
                      curve: Curves.bounceInOut,
                      child: const Icon(
                        Icons.send,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(
                height: 50,
              ),

              ///
              Container(width: double.infinity, child: Text("$text")),
            ],
          ),
        ),
      ),
    );
  }

  String text = '';
  bool isLoading = false;

  Future<void> getGemini(String question) async {
    setState(() {
      isLoading = true;
    });
    try {
      final geminis = Gemini.instance;
      final value = await geminis.text(question);
      if (value != null) {
        setState(() {
          text = value.output ?? "";
        });
      }
    } catch (e) {
      print("Error fetching Gemini text: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  ///---------------------------------- text speek---------------------------------->

  FlutterTts flutterTts = FlutterTts();
  Speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }
  StopSeak(){

  }
}
