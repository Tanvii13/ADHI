import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../widgets/app_shell.dart';

/// Hearing Assistant: records a short clip of ambient audio/speech and
/// sends it to the `/transcribe` endpoint, which returns a transcript plus
/// an urgent-sound classification (siren, smoke alarm, shouting, etc.).
class HearingPage extends StatefulWidget {
  const HearingPage({super.key});

  @override
  State<HearingPage> createState() => _HearingPageState();
}

class _HearingPageState extends State<HearingPage> {
  static const String _apiBase = "https://adhi-api.onrender.com";
  static const List<String> _watchedSounds = [
    "Siren", "Smoke alarm", "Shouting", "Knocking", "Doorbell",
  ];

  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLoading = false;

  String _transcript = "";
  String _soundEvent = "none";
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
      setState(() => _isRecording = false);
      if (path != null) {
        await _uploadAudio(path);
      }
      return;
    }

    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) {
      setState(() => _error = "Microphone permission was denied.");
      return;
    }

    String filePath;
    if (kIsWeb) {
      filePath = "adhi_clip.wav";
    } else {
      final dir = await getTemporaryDirectory();
      filePath = "${dir.path}/adhi_clip_${DateTime.now().millisecondsSinceEpoch}.wav";
    }

    await _recorder.start(const RecordConfig(encoder: AudioEncoder.wav), path: filePath);

    setState(() {
      _isRecording = true;
      _error = null;
      _transcript = "";
      _soundEvent = "none";
      _urgent = false;
    });
  }

  Future<void> _uploadAudio(String path) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final request = http.MultipartRequest("POST", Uri.parse("$_apiBase/transcribe"));
      request.files.add(await http.MultipartFile.fromPath("file", path));

      final streamedResponse = await request.send();
      final body = await streamedResponse.stream.bytesToString();
      final data = jsonDecode(body);

      if (data is Map && data.containsKey("error")) {
        setState(() => _error = data["error"].toString());
      } else {
        setState(() {
          _transcript = data["transcript"] ?? "";
          _soundEvent = data["sound_event"] ?? "none";
          _urgent = data["urgent"] == true;
        });
      }
    } catch (e) {
      setState(() => _error = "Could not reach the hearing assistant: $e");
    } finally {
      setState(() => _isLoading = false);
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
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              children: [
                Icon(Icons.hearing, size: 90, color: _urgent ? const Color(0xFFE5484D) : Colors.white),
                const SizedBox(height: 16),
                const Text("Hearing Assistant",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  "Record a few seconds of audio. ADHI transcribes speech and\nflags urgent sounds like sirens or smoke alarms.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: _watchedSounds.map((s) => _Chip(s)).toList(),
                ),
                const SizedBox(height: 28),
                Text(
                  _isRecording ? "Listening..." : "Tap to start recording",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _toggleRecording,
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                  label: Text(_isRecording ? "Stop & Transcribe" : "Start Recording"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isRecording ? const Color(0xFFE5484D) : const Color(0xFFB7E63E),
                    foregroundColor: const Color(0xFF062211),
                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading) const CircularProgressIndicator(color: Colors.white),
                if (_error != null) _ErrorPanel(message: _error!),
                if (!_isLoading && _transcript.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 10),
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
                        const Text("Transcript",
                            style: TextStyle(color: Color(0xFFB7E63E), fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 8),
                        Text(_transcript, style: const TextStyle(color: Colors.white, fontSize: 16)),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(
                              _urgent ? Icons.warning_amber_rounded : Icons.check_circle,
                              color: _urgent ? const Color(0xFFE5484D) : const Color(0xFFB7E63E),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Detected sound: $_soundEvent${_urgent ? ' (urgent!)' : ''}",
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          ],
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
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
    );
  }
}
