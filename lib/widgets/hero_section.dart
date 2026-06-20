import 'package:flutter/material.dart';
import '../theme.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      height: 500,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF163A28),
            Color(0xFF2D5A3D),
          ],
        ),
      ),

      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Row(
          children: [

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "ADHI: AI for\nIndependence,\nInclusion & Sight",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 58,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "Giving Sight, Hearing and Voice through AI.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 22,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [

                      ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          "Experience ADHI",
                        ),
                      ),

                      const SizedBox(width: 20),

                      OutlinedButton(
                        onPressed: () {},
                        child: const Text(
                          "Learn More",
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            Expanded(
              child: Center(
                child: Icon(
                  Icons.accessibility_new,
                  size: 250,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}