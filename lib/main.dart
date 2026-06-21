import 'dart:ui';
import 'package:flutter/material.dart';

import 'pages/vision_page.dart';
import 'pages/hearing_page.dart';
import 'pages/speech_page.dart';
import 'pages/about_page.dart';
import 'widgets/app_shell.dart';

void main() {
  runApp(const AdhiApp());
}

class AdhiApp extends StatelessWidget {
  const AdhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADHI Accessibility Platform',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF004D1A)),
      routes: {
        '/': (context) => const AdhiHomePage(),
        '/vision': (context) => const VisionPage(),
        '/hearing': (context) => const HearingPage(),
        '/speech': (context) => const SpeechPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

class AdhiHomePage extends StatelessWidget {
  const AdhiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/',
      body: Column(
        children: [
          const SizedBox(height: 40),

          const Text(
            "Accessibility is not a privilege; it is a right.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 40),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final cards = [
                  _GlassFeatureCard(
                    imagePath: 'assets/blind.png',
                    description:
                        'Giving eyes to 1 billion people by turning camera views into spoken descriptions.',
                    onTap: () => Navigator.pushNamed(context, '/vision'),
                  ),

                  _GlassFeatureCard(
                    imagePath: 'assets/deaf.png',
                    description:
                        'Giving ears to 70 million people by translating spoken words into live screen text.',
                    onTap: () => Navigator.pushNamed(context, '/hearing'),
                  ),

                  _GlassFeatureCard(
                    imagePath: 'assets/mute.png',
                    description:
                        'Giving a voice to 6.5 million people by converting typed phrases into digital speech.',
                    onTap: () => Navigator.pushNamed(context, '/speech'),
                  ),
                ];

                if (constraints.maxWidth > 1000) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: cards[0]),
                      const SizedBox(width: 18),
                      Expanded(child: cards[1]),
                      const SizedBox(width: 18),
                      Expanded(child: cards[2]),
                    ],
                  );
                }

                return Column(
                  children: [
                    cards[0],
                    const SizedBox(height: 20),
                    cards[1],
                    const SizedBox(height: 20),
                    cards[2],
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 50),

          const Text(
            "The World Adapts To You",
            style: TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _GlassFeatureCard extends StatelessWidget {
  final String imagePath;
  final String description;
  final VoidCallback onTap;

  const _GlassFeatureCard({
    required this.imagePath,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      hoverColor: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- Image ---
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox(
              height: 280,
              width: double.infinity,
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 22),

          // --- Floating glass caption card ---
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.16)),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.14),
                      Colors.white.withOpacity(0.04),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.35),
                      blurRadius: 22,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    height: 1.55,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
