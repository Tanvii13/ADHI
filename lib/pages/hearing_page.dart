import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/glass.dart';

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

  static const List<Duration> _retryDelays = [
    Duration(seconds: 3),
    Duration(seconds: 6),
    Duration(seconds: 10),
  ];

  final AudioRecorder _recorder = AudioRecorder();

  bool _isRecording = false;
  bool _isLoading = false;

  String _transcript = "";
  String _soundEvent = "None";
  bool _urgent = false;
  String? _error;
  String? _statusMessage;

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
      setState(() => _error = "Microphone permission denied");
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

  Future<http.StreamedResponse> _sendRequestWithTimeout(
    http.MultipartRequest request,
  ) async {
    return await request.send().timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw Exception("Request timeout - backend not responding");
      },
    );
  }

  Future<void> _uploadAudio(String path) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _statusMessage = null;
    });

    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse("$_apiBase/transcribe"),
      );

      if (kIsWeb) {
        final blobResponse = await http.get(Uri.parse(path));
        request.files.add(
          http.MultipartFile.fromBytes(
            "file",
            blobResponse.bodyBytes,
            filename: "recording.wav",
          ),
        );
      } else {
        request.files.add(await http.MultipartFile.fromPath("file", path));
      }

      final response = await _sendRequestWithTimeout(request);
      final body = await response.stream.bytesToString();

      final data = jsonDecode(body);

      if (!mounted) return;

      setState(() {
        _transcript = data["transcript"] ?? "";
        _soundEvent = data["sound_event"] ?? "None";
        _urgent = data["urgent"] ?? false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = "Hearing assistant failed. Please try again.\n$e";
      });
    } finally {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _statusMessage = null;
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
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 56),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              children: [
                SectionHeader(
                  title: "Hearing Assistant",
                  subtitle:
                      "Record speech and ambient sound — ADHI converts it into text.",
                  icon: Icons.hearing_rounded,
                  iconColor: _urgent
                      ? const Color(0xFFE5484D)
                      : AppColors.accentLime,
                ),

                const SizedBox(height: 36),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _watchedSounds.map((e) => _Chip(e)).toList(),
                ),

                const SizedBox(height: 48),

                PulsingRecordButton(
                  isRecording: _isRecording,
                  isLoading: _isLoading,
                  onPressed: _toggleRecording,
                ),

                const SizedBox(height: 18),

                Text(
                  _isLoading
                      ? "Processing audio..."
                      : _isRecording
                      ? "Listening... tap to stop"
                      : "Tap to start recording",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 16,
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 20),
                  GlassPanel(
                    borderColor: Colors.redAccent,
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],

                if (_transcript.isNotEmpty) ...[
                  const SizedBox(height: 30),
                  GlassPanel(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transcript",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _transcript,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
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
