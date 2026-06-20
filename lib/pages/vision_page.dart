import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  PlatformFile? selectedFile;

  String fileName = "No image selected";
  String description = "";
  bool isLoading = false;

  Future<void> pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        selectedFile = result.files.first;
        fileName = selectedFile!.name;
      });

      await uploadImage();
    }
  }

  Future<void> uploadImage() async {
    if (selectedFile == null) return;

    setState(() {
      isLoading = true;
      description = "";
    });

    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("http://127.0.0.1:8000/describe"),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          "file",
          selectedFile!.path!,
        ),
      );

      var response = await request.send();

      var responseBody = await response.stream.bytesToString();

      var data = jsonDecode(responseBody);

      setState(() {
        description = data["description"];
      });
    } catch (e) {
      setState(() {
        description = "Error: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vision Assistant"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              children: [
                const SizedBox(height: 20),

                const Icon(
                  Icons.visibility,
                  size: 100,
                ),

                const SizedBox(height: 20),

                Text(
                  fileName,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: pickImage,
                  child: const Text("Upload Image"),
                ),

                const SizedBox(height: 30),

                if (isLoading)
                  const CircularProgressIndicator(),

                if (!isLoading && description.isNotEmpty)
                  Container(
                    width: 700,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}