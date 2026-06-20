import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 40,
        horizontal: 30,
      ),
      color: const Color(0xFF08120E),
      child: const Column(
        children: [
          Text(
            "ADHI",
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            "AI-Powered Accessibility Platform",
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Inspired by Anita & Dhiren • Accessibility for Everyone",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}