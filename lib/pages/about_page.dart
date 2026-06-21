import 'package:flutter/material.dart';

import '../widgets/app_shell.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/about',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ADHI: AI for Independence, Inclusion & Sight",
                  style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  "ADHI is an accessibility platform that gives:",
                  style: TextStyle(color: Colors.white70, fontSize: 16, height: 1.6),
                ),
                const SizedBox(height: 16),
                const _Bullet("Sight — describing the world to the 1 billion+ people who are blind or low-vision."),
                const _Bullet("Hearing — turning spoken words and urgent sounds into live text for the 70 million+ who are deaf or hard of hearing."),
                const _Bullet("Voice — converting typed phrases into natural speech for the 6.5 million+ who are nonverbal or speech-impaired."),
                const SizedBox(height: 24),
                const Text(
                  "Accessibility is not a privilege; it is a right.",
                  style: TextStyle(color: Color(0xFFB7E63E), fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6, right: 10),
            child: Icon(Icons.circle, size: 6, color: Color(0xFFB7E63E)),
          ),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
          ),
        ],
      ),
    );
  }
}
