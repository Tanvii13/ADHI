import 'package:flutter/material.dart';
import '../theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      padding: const EdgeInsets.all(50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: AppColors.panel,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth > 700;

          final textColumn = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ADHI: AI for\nIndependence,\nInclusion & Sight",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 25),
              const Text(
                "Giving Sight, Hearing and Voice through AI.",
                style: TextStyle(color: Colors.white70, fontSize: 20),
              ),
              const SizedBox(height: 30),
              Wrap(
                spacing: 20,
                runSpacing: 12,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/vision'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentLime,
                      foregroundColor: AppColors.background,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text("Experience ADHI", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Scroll down to learn more!")),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text("Learn More"),
                  ),
                ],
              ),
            ],
          );

          final icon = Icon(
            Icons.accessibility_new,
            size: 220,
            color: AppColors.accentLime.withOpacity(0.35),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(child: textColumn),
                Expanded(child: Center(child: icon)),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textColumn,
              const SizedBox(height: 30),
              Center(child: icon),
            ],
          );
        },
      ),
    );
  }
}