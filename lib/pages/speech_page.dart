import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/glass.dart';
class SpeechPage extends StatefulWidget {
  const SpeechPage({super.key});

  @override
  State<SpeechPage> createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
  static const List<String> _quickPhrases = [
    "Yes", "No", "Thank you", "Please wait", "I need help", "Excuse me",
  ];

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

  Future<void> _speak([String? text]) async {
    final toSpeak = (text ?? _controller.text).trim();
    if (toSpeak.isEmpty) return;
    await _tts.setSpeechRate(_rate);
    await _tts.speak(toSpeak);
  }

  Future<void> _stop() async {
    await _tts.stop();
    setState(() => _isSpeaking = false);
  }

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/speech',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 56, horizontal: 30),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 880),
            child: Column(
              children: [
                SectionHeader(
                  title: "Voice Assistant",
                  subtitle:
                      "Type a phrase, or tap a quick phrase below,\nand ADHI will speak it aloud for you.",
                  icon: Icons.record_voice_over_rounded,
                ),

                const SizedBox(height: 36),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: _quickPhrases
                      .map((p) => _QuickPhraseChip(
                            label: p,
                            onTap: () => _speak(p),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 36),

                GlassPanel(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.edit_note_rounded,
                              color: AppColors.accentLime, size: 24),
                          const SizedBox(width: 8),
                          const Text(
                            "What would you like to say?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GlassTextField(
                        controller: _controller,
                        hintText: "Type what you want to say...",
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          const Icon(Icons.speed_rounded,
                              color: Colors.white70, size: 20),
                          const SizedBox(width: 10),
                          const Text("Speed",
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: AppColors.accentLime,
                                inactiveTrackColor: Colors.white24,
                                thumbColor: AppColors.accentLime,
                                overlayColor:
                                    AppColors.accentLime.withOpacity(0.2),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: _rate,
                                min: 0.1,
                                max: 1.0,
                                onChanged: (v) => setState(() => _rate = v),
                              ),
                            ),
                          ),
                          Text(
                            "${(_rate * 100).round()}%",
                            style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PremiumButton(
                            label: "Speak",
                            icon: Icons.volume_up_rounded,
                            onPressed: _isSpeaking ? null : () => _speak(),
                          ),
                          const SizedBox(width: 16),
                          PremiumButton(
                            label: "Stop",
                            icon: Icons.stop_rounded,
                            outlined: true,
                            onPressed: _isSpeaking ? _stop : null,
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

class _QuickPhraseChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickPhraseChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
  
    return Material(
      type: MaterialType.transparency,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
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
        ),
      ),
    );
  }
}
