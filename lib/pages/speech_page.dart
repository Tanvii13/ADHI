import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Voice Assistant: converts typed phrases into digital speech entirely
/// on-device via flutter_tts (no backend round-trip needed).
class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _controller = TextEditingController();

  bool _isSpeaking = false;
  double _rate = 0.5;

  @override
  void initState() {
    super.initState();
    _tts.setStartHandler(() => setState(() => _isSpeaking = true));
    _tts.setCompletionHandler(() => setState(() => _isSpeaking = false));
    _tts.setCancelHandler(() => setState(() => _isSpeaking = false));
    _tts.setErrorHandler((msg) => setState(() => _isSpeaking = false));
  }

  @override
  void dispose() {
    _tts.stop();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _speak() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    await _tts.setSpeechRate(_rate);
    await _tts.speak(text);
  }

  Future<void> _stop() async {
    await _tts.stop();
    setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062211),
      appBar: AppBar(
        backgroundColor: const Color(0xFF062211),
        foregroundColor: Colors.white,
        title: const Text("Voice Assistant"),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              children: [
                const Icon(Icons.record_voice_over, size: 90, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  "Type a phrase below and ADHI will speak it aloud for you.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  maxLines: 4,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Type what you want to say...",
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text("Speed", style: TextStyle(color: Colors.white70)),
                    Expanded(
                      child: Slider(
                        value: _rate,
                        min: 0.1,
                        max: 1.0,
                        activeColor: const Color(0xFFB7E63E),
                        onChanged: (v) => setState(() => _rate = v),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isSpeaking ? null : _speak,
                      icon: const Icon(Icons.volume_up),
                      label: const Text("Speak"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB7E63E),
                        foregroundColor: const Color(0xFF062211),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: _isSpeaking ? _stop : null,
                      icon: const Icon(Icons.stop),
                      label: const Text("Stop"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
