import 'package:flutter/material.dart';

void main() => runApp(const AdhiApp());

class AdhiApp extends StatelessWidget {
  const AdhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADHI Accessibility Platform',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF032612)), // Dark forest green background
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
            // 1. Navigation Header Bar
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo Placeholder branding
                  Row(
                    children: [
                      Image.asset('logo.jpg', height: 40, errorBuilder: (c, e, s) => const Icon(Icons.accessibility, color: Color(0xFF032612), size: 40)),
                      const SizedBox(width: 10),
                      const Text('ADHI', style: TextStyle(color: Color(0xFF032612), fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                    ],
                  ),
                  // Navigation Links
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
            const SizedBox(height: 40),

            // 2. Banner Core Hero Text Headline
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Accessibility is not a privilege; it is a right.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ),
            const SizedBox(height: 40),

            // 3. Grid Feature Matrix Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Make it responsive: grid layout if wide screen desktop, otherwise stack vertically on mobile screens
                  if (constraints.maxWidth > 900) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Expanded(child: _FeatureCard(imageAsset: 'blind.png', description: 'Giving eyes to 1 billion people by turning camera views into spoken descriptions.')),
                        SizedBox(width: 25),
                        Expanded(child: _FeatureCard(imageAsset: 'deaf.png', description: 'Giving ears to 70 million people by translating spoken words into live screen text.')),
                        SizedBox(width: 25),
                        Expanded(child: _FeatureCard(imageAsset: 'mute.png', description: 'Giving a voice to 6.5 million people by converting typed phrases into digital speech.')),
                      ],
                    );
                  } else {
                    return Column(
                      children: const [
                        _FeatureCard(imageAsset: 'blind.png', description: 'Giving eyes to 1 billion people by turning camera views into spoken descriptions.'),
                        SizedBox(height: 30),
                        _FeatureCard(imageAsset: 'deaf.png', description: 'Giving ears to 70 million people by translating spoken words into live screen text.'),
                        SizedBox(height: 30),
                        _FeatureCard(imageAsset: 'mute.png', description: 'Giving a voice to 6.5 million people by converting typed phrases into digital speech.'),
                      ],
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 40),

            // 4. Subtitle Callout Text
            const Text(
              'The World Adapts To You',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, letterSpacing: 0.8),
            ),
            const SizedBox(height: 50),

            // 5. System Footer Layout Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('ADHI copyright 2026', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  Row(
                    children: const [
                      Text('Made with ', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      Icon(Icons.favorite, color: Colors.red, size: 16),
                      Text(' by Tanvi', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.bold)),
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

// Reusable Custom Navigation Link Widget Element
class _NavLink extends StatelessWidget {
  final String title;
  final bool isSelected;
  const _NavLink(this.title, {this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: TextStyle(
          color: const Color(0xFF032612),
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          decoration: isSelected ? TextDecoration.underline : TextDecoration.none,
        ),
      ),
    );
  }
}

// Reusable Custom Grid Feature Card Component Container
class _FeatureCard extends StatelessWidget {
  final String imageAsset;
  final String description;
  const _FeatureCard({required this.imageAsset, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF053B1C), // Slightly lighter green accent for the panel background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image Section Box Frame
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
            child: AspectRatio(
              aspectRatio: 1.3,
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.image, color: Colors.white38, size: 40),
                  );
                },
              ),
            ),
          ),
          // Description Content Text Box
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
