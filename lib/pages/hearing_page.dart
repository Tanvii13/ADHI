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

  // Render's free tier spins the service down after ~15 min idle. The
  // first request after that can fail or hang while it cold-starts, so
  // we retry a few times with backoff instead of showing a scary error
  // on the very first attempt.
  static const List<Duration> _retryDelays = [
    Duration(seconds: 4),
    Duration(seconds: 8),
    Duration(seconds: 12),
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

  Future<http.StreamedResponse> _sendWithRetry(
    Future<http.MultipartRequest> Function() buildRequest,
  ) async {
    Object? lastError;

    for (var attempt = 0; attempt <= _retryDelays.length; attempt++) {
      try {
        final request = await buildRequest();
        return await request.send();
      } catch (e) {
        lastError = e;

        if (attempt < _retryDelays.length) {
          setState(() {
            _statusMessage =
                "The assistant is waking up (this can take a little while on the first request)…";
          });
          await Future.delayed(_retryDelays[attempt]);
        }
      }
    }

    throw lastError ?? Exception("Unknown error contacting the assistant");
  }

  Future<void> _uploadAudio(String path) async {
    setState(() {
      _isLoading = true;
      _error = null;
      _statusMessage = null;
    });

    try {
      if (kIsWeb) {
        setState(() {
          _error =
              "Audio upload from browser is limited. Test Hearing Assistant on Android/Desktop.";
        });
        return;
      }

      final response = await _sendWithRetry(() async {
        final request = http.MultipartRequest(
          "POST",
          Uri.parse("$_apiBase/transcribe"),
        );
        request.files.add(await http.MultipartFile.fromPath("file", path));
        return request;
      });

      final body = await response.stream.bytesToString();

      final data = jsonDecode(body);

      setState(() {
        _transcript = data["transcript"] ?? "";
        _soundEvent = data["sound_event"] ?? "None";
        _urgent = data["urgent"] ?? false;
      });
    } catch (e) {
      setState(() {
        _error =
            "Could not reach the hearing assistant after several attempts. It may be waking up from sleep — please try again in a moment.\n($e)";
      });
    } finally {
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
                      "Record speech and ambient sound — ADHI turns it into\nreadable text and flags urgent alerts instantly.",
                  icon: Icons.hearing_rounded,
                  iconColor: _urgent
                      ? const Color(0xFFE5484D)
                      : AppColors.accentLime,
                ),

                const SizedBox(height: 36),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: _watchedSounds
                      .map((sound) => _Chip(sound))
                      .toList(),
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
                      ? "Processing audio…"
                      : _isRecording
                          ? "Listening… tap to stop"
                          : "Tap to start recording",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if (_statusMessage != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    _statusMessage!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],

                const SizedBox(height: 36),

                if (_error != null) _ErrorPanel(message: _error!),

                if (_transcript.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: GlassPanel(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.subtitles_rounded,
                                  color: AppColors.accentLime, size: 26),
                              const SizedBox(width: 10),
                              const Text(
                                "Transcript",
                                style: TextStyle(
                                  color: AppColors.accentLime,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _transcript,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: _urgent
                                  ? const Color(0xFFE5484D).withOpacity(0.18)
                                  : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _urgent
                                    ? const Color(0xFFE5484D)
                                    : Colors.white24,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _urgent
                                      ? Icons.warning_amber_rounded
                                      : Icons.graphic_eq_rounded,
                                  size: 20,
                                  color: _urgent
                                      ? const Color(0xFFE5484D)
                                      : Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Detected Sound: $_soundEvent",
                                  style: TextStyle(
                                    color: _urgent
                                        ? const Color(0xFFE5484D)
                                        : Colors.white70,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
    return GlassPanel(
      borderColor: const Color(0xFFE5484D).withOpacity(0.5),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Color(0xFFE5484D)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
