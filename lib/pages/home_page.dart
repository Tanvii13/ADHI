import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Widget featureImage({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 280,
        height: 360,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black26,
              offset: Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.55),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget glassCard(String title, String description) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF071B12),
            Color(0xFF0D2A1B),
            Color(0xFF071B12),
          ],
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),

            const Text(
              "Accessibility is not a privilege;\nit is a right.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 54,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Empowering independence through AI",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),

            const SizedBox(height: 70),

            Wrap(
              spacing: 30,
              runSpacing: 30,
              alignment: WrapAlignment.center,
              children: [
                featureImage(
                  context: context,
                  imagePath: "assets/hearing.jpg",
                  title: "Hearing Assistant",
                  route: "/hearing",
                ),
                featureImage(
                  context: context,
                  imagePath: "assets/vision.jpg",
                  title: "Vision Assistant",
                  route: "/vision",
                ),
                featureImage(
                  context: context,
                  imagePath: "assets/speech.jpg",
                  title: "Voice Assistant",
                  route: "/speech",
                ),
              ],
            ),

            const SizedBox(height: 80),

            Wrap(
              spacing: 25,
              runSpacing: 25,
              alignment: WrapAlignment.center,
              children: [
                glassCard(
                  "Hear",
                  "Convert speech into readable text instantly.",
                ),
                glassCard(
                  "See",
                  "Understand surroundings through image analysis.",
                ),
                glassCard(
                  "Speak",
                  "Convert text into natural sounding speech.",
                ),
              ],
            ),

            const SizedBox(height: 100),

            const Text(
              "The World Adapts To You",
              style: TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}