import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const AdhiApp());

class AdhiApp extends StatelessWidget {
  const AdhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADHI Accessibility Platform',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF062211)), // Deep forest green
      home: const AdhiHomePage(),
    );
  }
}

class AdhiHomePage extends StatelessWidget {
  const AdhiHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Navigation Header Bar (White)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Explicit path routing for web asset loading
                      Image.asset('assets/logo.jpg', height: 35, errorBuilder: (c, e, s) => const Icon(Icons.circle, color: Color(0xFF13502B))),
                      const SizedBox(width: 12),
                      const Text('ADHI', style: TextStyle(color: Color(0xFF0F3E21), fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    ],
                  ),
                  Row(
                    children: const [
                      _NavLink('Home', isSelected: true),
                      _NavLink('Hearing Assistant'),
                      _NavLink('Vision Assistant'),
                      _NavLink('Voice Assistant'),
                      _NavLink('More'),
                      _NavLink('About'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),

            // 2. Main Title Banner Message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Accessibility is not a privilege; it is a right.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(height: 50),

            // 3. Grid Row of Interactive Glass Feature Matrix Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 950) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _GlassFeatureCard(imagePath: 'assets/blind.png', description: 'Giving eyes to 1 billion people by turning camera views into spoken descriptions.')),
                        SizedBox(width: 30),
                        Expanded(child: _GlassFeatureCard(imagePath: 'assets/deaf.png', description: 'Giving ears to 70 million people by translating spoken words into live screen text.')),
                        SizedBox(width: 30),
                        Expanded(child: _GlassFeatureCard(imagePath: 'assets/mute.png', description: 'Giving a voice to 6.5 million people by converting typed phrases into digital speech.')),
                      ],
                    );
                  } else {
                    return Column(
                      children: const [
                        _GlassFeatureCard(imagePath: 'assets/blind.png', description: 'Giving eyes to 1 billion people by turning camera views into spoken descriptions.'),
                        SizedBox(height: 35),
                        _GlassFeatureCard(imagePath: 'assets/deaf.png', description: 'Giving ears to 70 million people by translating spoken words into live screen text.'),
                        SizedBox(height: 35),
                        _GlassFeatureCard(imagePath: 'assets/mute.png', description: 'Giving a voice to 6.5 million people by converting typed phrases into digital speech.'),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 60),

            // 4. Subtitle Content Slogan
            const Text(
              'The World Adapts To You',
              style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 0.8),
            ),
            const SizedBox(height: 80),

            // 5. System Footer Layout Bar (White)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ADHI copyright 2026', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)),
                  Row(
                    children: [
                      const Text('Made with ', style: TextStyle(color: Colors.black54, fontSize: 14, fontWeight: FontWeight.w500)),
                      Image.asset('assets/logo.jpg', height: 16, errorBuilder: (c, e, s) => const Icon(Icons.favorite, color: Colors.red, size: 14)), // Small image icon fix
                      const Text(' by Tanvi', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final bool isSelected;
  const _NavLink(this.title, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black87,
          fontSize: 15,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }
}

// 6. Upgraded Component Card Incorporating Transparent Glassmorphism Effect
class _GlassFeatureCard extends StatelessWidget {
  final String imagePath;
  final String description;
  const _GlassFeatureCard({required this.imagePath, required this.description});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
          // Subtle linear gradient to achieve depth and reflective finish
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.08),
              Colors.white.withOpacity(0.02),
            ],
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), // Native glass blur engine
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 1.35,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.white12,
                      child: const Icon(Icons.broken_image, color: Colors.white30, size: 40),
                    );
                  },
                ),
              ),
              Container(
                color: const Color(0xFF032612).withOpacity(0.4), // Semi-transparent text background container panel
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFF90CFA8), fontSize: 14, height: 1.6, fontWeight: FontWeight.w500, letterSpacing: 0.2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
