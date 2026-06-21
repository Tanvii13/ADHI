import 'dart:ui';
import 'package:flutter/material.dart';

import 'pages/vision_page.dart';
import 'pages/hearing_page.dart';
import 'pages/speech_page.dart';
import 'pages/about_page.dart';

void main() => runApp(const AdhiApp());

class AdhiApp extends StatelessWidget {
  const AdhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ADHI Accessibility Platform',
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xFF062211)),
      initialRoute: '/',
      routes: {
        '/': (context) => const AdhiHomePage(),
        '/vision': (context) => const VisionPage(),
        '/hearing': (context) => const HearingPage(),
        '/speech': (context) => const SpeechPage(),
        '/about': (context) => const AboutPage(),
      },
      // Unknown route fallback instead of a blank/broken screen.
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (context) => const AdhiHomePage(),
      ),
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
              child: LayoutBuilder(builder: (context, constraints) {
                final logoRow = Row(
                  children: [
                    Image.asset('assets/logo.jpg', height: 35,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.circle, color: Color(0xFF13502B))),
                    const SizedBox(width: 12),
                    const Text('ADHI',
                        style: TextStyle(
                            color: Color(0xFF0F3E21),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                  ],
                );

                final navRow = Wrap(
                  alignment: WrapAlignment.end,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _NavLink('Home', isSelected: true, onTap: () {}),
                    _NavLink('Hearing Assistant',
                        onTap: () => Navigator.pushNamed(context, '/hearing')),
                    _NavLink('Vision Assistant',
                        onTap: () => Navigator.pushNamed(context, '/vision')),
                    _NavLink('Voice Assistant',
                        onTap: () => Navigator.pushNamed(context, '/speech')),
                    _NavLink('More', onTap: () => _showMoreMenu(context)),
                    _NavLink('About',
                        onTap: () => Navigator.pushNamed(context, '/about')),
                  ],
                );

                if (constraints.maxWidth > 760) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [logoRow, navRow],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    logoRow,
                    const SizedBox(height: 12),
                    navRow,
                  ],
                );
              }),
            ),
            const SizedBox(height: 60),

            // 2. Main Title Banner Message
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Accessibility is not a privilege; it is a right.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5),
              ),
            ),
            const SizedBox(height: 50),

            // 3. Grid Row of Interactive Glass Feature Matrix Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60),
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

                  if (constraints.maxWidth > 950) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: cards[0]),
                        const SizedBox(width: 30),
                        Expanded(child: cards[1]),
                        const SizedBox(width: 30),
                        Expanded(child: cards[2]),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        cards[0],
                        const SizedBox(height: 35),
                        cards[1],
                        const SizedBox(height: 35),
                        cards[2],
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
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8),
            ),
            const SizedBox(height: 80),

            // 5. System Footer Layout Bar (White)
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                runSpacing: 8,
                children: [
                  const Text('ADHI copyright 2026',
                      style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Made with ',
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                      const Text('❤️', style: TextStyle(fontSize: 14)),
                      const Text(' by Tanvi',
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.bold)),
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

  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About ADHI'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/about');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavLink(this.title, {this.isSelected = false, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.title,
            style: TextStyle(
              color: _hovering ? const Color(0xFF13502B) : Colors.black87,
              fontSize: 15,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.w500,
              decoration:
                  _hovering ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

// 6. Upgraded Component Card Incorporating Transparent Glassmorphism Effect
class _GlassFeatureCard extends StatelessWidget {
  final String imagePath;
  final String description;
  final VoidCallback onTap;
  const _GlassFeatureCard(
      {required this.imagePath, required this.description, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
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
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
                        child: const Icon(Icons.broken_image,
                            color: Colors.white30, size: 40),
                      );
                    },
                  ),
                ),
                Container(
                  color: const Color(0xFF032612).withOpacity(0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF90CFA8),
                        fontSize: 14,
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2),
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
