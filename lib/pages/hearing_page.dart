import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../widgets/app_shell.dart';

class HearingPage extends StatefulWidget {
  const HearingPage({super.key});

  @override
  State<HearingPage> createState() => _HearingPageState();
}

class _HearingPageState extends State<HearingPage> {
  static const String _apiBase = "https://adhi-api.onrender.com";

  static const List<String> _watchedSounds = [
    "Siren",
    "Smoke Alarm",
    "Shouting",
    "Knocking",
    "Doorbell",
  ];

  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLoading = false;

  String _transcript = "";
  String _soundEvent = "None";
  bool _urgent = false;
  String? _error;

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      final path = await _recorder.stop();

      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        await _uploadAudio(path);
      }

      return;
    }

    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      setState(() {
        _error = "Microphone permission denied";
      });
      return;
    }

    String filePath = "recording.wav";

    if (!kIsWeb) {
      final dir = await getTemporaryDirectory();
      filePath = "${dir.path}/recording.wav";
    }

    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.wav),
      path: filePath,
    );

    setState(() {
      _isRecording = true;
      _error = null;
      _transcript = "";
    });
  }

  Future<void> _uploadAudio(String path) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (kIsWeb) {
        setState(() {
          _error =
              "Audio upload from browser is limited. Test Hearing Assistant on Android/Desktop.";
        });
        return;
      }

      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$_apiBase/transcribe"),
      );

      request.files.add(await http.MultipartFile.fromPath("file", path));

      final response = await request.send();

      final body = await response.stream.bytesToString();

      final data = jsonDecode(body);

      setState(() {
        _transcript = data["transcript"] ?? "";
        _soundEvent = data["sound_event"] ?? "None";
        _urgent = data["urgent"] ?? false;
      });
    } catch (e) {
      setState(() {
        _error = "Error: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });

      if (!kIsWeb) {
        final file = File(path);

        if (await file.exists()) {
          await file.delete();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/hearing',
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              children: [
                Icon(
                  Icons.hearing,
                  size: 100,
                  color: _urgent
                      ? const Color(0xFFE5484D)
                      : const Color(0xFFB7E63E),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Hearing Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Record speech and convert it into readable text instantly.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 20),
                ),

                const SizedBox(height: 30),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _watchedSounds
                      .map((sound) => _Chip(sound))
                      .toList(),
                ),

                const SizedBox(height: 35),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _toggleRecording,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(
                    _isRecording ? "Stop Recording" : "Start Recording",
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording
                        ? Colors.red
                        : const Color(0xFFB7E63E),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                if (_isLoading) const CircularProgressIndicator(),

                if (_error != null) _ErrorPanel(message: _error!),

                if (_transcript.isNotEmpty)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transcript",
                          style: TextStyle(
                            color: Color(0xFFB7E63E),
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          _transcript,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "Detected Sound: $_soundEvent",
                          style: TextStyle(
                            color: _urgent ? Colors.red : Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
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

class _ErrorPanel extends StatelessWidget {
  final String message;

  const _ErrorPanel({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;

  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white)),
    );
  }
}
