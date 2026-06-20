import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';
import '../widgets/feature_card.dart';
import '../widgets/footer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CustomNavbar(),
            const HeroSection(),

            const SizedBox(height: 80),

            const Text(
              "Core Features",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: const [
                FeatureCard(
                  icon: Icons.visibility,
                  title: "Vision Assistant",
                  description:
                      "Describe surroundings and objects for visually impaired users.",
                ),
                FeatureCard(
                  icon: Icons.record_voice_over,
                  title: "Speech Assistant",
                  description:
                      "Convert text into natural speech instantly.",
                ),
                FeatureCard(
                  icon: Icons.hearing,
                  title: "Hearing Assistant",
                  description:
                      "Convert spoken language into readable text.",
                ),
              ],
            ),

            const SizedBox(height: 100),

            const Footer(),
          ],
        ),
      ),
    );
  }
}