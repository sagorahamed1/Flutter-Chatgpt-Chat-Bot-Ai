import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class AiAssistant extends StatelessWidget {
  const AiAssistant({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Assistant'),
      ),
      body: const AiWithImage(),
    );
  }
}

class AiWithImage extends StatefulWidget {
  const AiWithImage({Key? key}) : super(key: key);

  @override
  State<AiWithImage> createState() => _AiWithImageState();
}

class _AiWithImageState extends State<AiWithImage> {
  late String _text;
  late Uint8List _imageBytes;
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _text = '';
    _imageBytes = Uint8List(0);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_imageBytes.isNotEmpty)
            Center(
              child: Column(
                children: [
                  Text(
                    _text,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Image.memory(
                    _imageBytes,
                    height: 200,
                    width: 200,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: "Enter your questions",
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: _pickImage,
                child: const Text("Select Image"),
              ),
              TextButton(
                onPressed: _getGeminiWithImage,
                child: const Text("Show Answer"),
              ),
            ],
          ),
        ],
      ),
    );
  }



  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = Uint8List.fromList(fileBytes);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("No image selected"),
      ));
    }
  }



  Future<void> _getGeminiWithImage() async {
    if (_imageBytes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please select an image"),
      ));
      return;
    }

    try {
      final geminis = Gemini.instance;
      final value = await geminis.textAndImage(text: _textController.text, images: [_imageBytes]);
      if (value != null) {
        setState(() {
          _text = value.output ?? "";
        });
      }
    } catch (e) {
      print("Error fetching Gemini text: $e");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error fetching text from Gemini"),
      ));
    }
  }
}
