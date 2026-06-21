import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_shell.dart';

/// Vision Assistant: upload a photo, get back a spoken-style description
/// plus the full structured breakdown the backend already provides —
/// notable objects, hazards/safety risks, and any text detected in the
/// image (signage, labels, etc.).
class VisionPage extends StatefulWidget {
  const VisionPage({super.key});

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  static const String _apiBase = "https://adhi-api.onrender.com";

  PlatformFile? selectedFile;

  String fileName = "No image selected";
  String description = "";
  List<String> objects = [];
  List<String> hazards = [];
  String? textDetected;
  bool isLoading = false;
  String? error;

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      selectedFile = result.files.first;
      fileName = selectedFile!.name;
    });

    await uploadImage();
  }

  Future<void> uploadImage() async {
    if (selectedFile == null) return;

    setState(() {
      isLoading = true;
      description = "";
      objects = [];
      hazards = [];
      textDetected = null;
      error = null;
    });

    try {
      final request = http.MultipartRequest("POST", Uri.parse("$_apiBase/describe"));

      if (selectedFile!.bytes != null) {
        // Web: no real file path, use in-memory bytes instead.
        request.files.add(http.MultipartFile.fromBytes(
          "file",
          selectedFile!.bytes!,
          filename: selectedFile!.name,
        ));
      } else if (selectedFile!.path != null) {
        request.files.add(await http.MultipartFile.fromPath("file", selectedFile!.path!));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final data = jsonDecode(responseBody);

      if (data is Map && data.containsKey("error")) {
        setState(() => error = data["error"].toString());
      } else {
        setState(() {
          description = data["description"] ?? "";
          objects = List<String>.from(data["objects"] ?? []);
          hazards = List<String>.from(data["hazards"] ?? []);
          textDetected = data["text_detected"];
        });
      }
    } catch (e) {
      setState(() => error = "Could not reach the vision assistant: $e");
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/vision',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                const Icon(Icons.visibility, size: 90, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  "Vision Assistant",
                  style: TextStyle(
                      color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Upload a photo and ADHI will describe the scene, flag hazards,\nand read out any visible text.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 28),
                Text(fileName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white60, fontSize: 13)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: isLoading ? null : pickImage,
                  icon: const Icon(Icons.upload),
                  label: const Text("Upload Image"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB7E63E),
                    foregroundColor: const Color(0xFF062211),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 30),
                if (isLoading) const CircularProgressIndicator(color: Colors.white),
                if (error != null)
                  _ErrorPanel(message: error!),
                if (!isLoading && description.isNotEmpty) ...[
                  _ResultPanel(
                    title: "Scene Description",
                    icon: Icons.remove_red_eye,
                    child: Text(description,
                        style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.5)),
                  ),
                  if (objects.isNotEmpty)
                    _ResultPanel(
                      title: "Objects Detected",
                      icon: Icons.category,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: objects.map((o) => _Chip(o)).toList(),
                      ),
                    ),
                  if (hazards.isNotEmpty)
                    _ResultPanel(
                      title: "Hazards & Safety Risks",
                      icon: Icons.warning_amber_rounded,
                      accent: const Color(0xFFE5484D),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: hazards
                            .map((h) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text("• $h",
                                      style: const TextStyle(color: Colors.white, fontSize: 14)),
                                ))
                            .toList(),
                      ),
                    ),
                  if (textDetected != null && textDetected!.trim().isNotEmpty)
                    _ResultPanel(
                      title: "Text Detected",
                      icon: Icons.text_fields,
                      child: Text(textDetected!,
                          style: const TextStyle(color: Colors.white, fontSize: 15)),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultPanel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  final Color accent;
  const _ResultPanel({
    required this.title,
    required this.icon,
    required this.child,
    this.accent = const Color(0xFFB7E63E),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: accent, size: 18),
              const SizedBox(width: 8),
              Text(title,
                  style: TextStyle(
                      color: accent, fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ErrorPanel extends StatelessWidget {
  final String message;
  const _ErrorPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE5484D).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5484D)),
      ),
      child: Text(message, style: const TextStyle(color: Colors.white)),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFB7E63E).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB7E63E).withOpacity(0.4)),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white, fontSize: 13)),
    );
  }
}
