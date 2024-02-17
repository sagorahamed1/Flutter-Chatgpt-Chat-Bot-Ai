import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class AiWithText extends StatefulWidget {
  const AiWithText({Key? key}) : super(key: key);

  @override
  State<AiWithText> createState() => _AiWithTextState();
}

class _AiWithTextState extends State<AiWithText> {
  String text = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getGemini(controller.text);
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: text==null
                    ? CircularProgressIndicator()
                    : SingleChildScrollView(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter your questions",
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                getGemini(controller.text);
              },
              child: const Text("Show Text"),
            ),
          ],
        ),
      ),
    );
  }

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
}
