import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/glass.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      currentRoute: '/about',
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              children: [
                Text(
                  "ADHI",
                  style: TextStyle(
                    color: AppColors.accentLime,
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 4,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "AI for Disability, Human Inclusion & Independence",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  "ADHI is an accessibility platform that gives sight, hearing\n"
                  "and a voice back to the people who need it most — built on\n"
                  "the belief that the world should adapt to people, not the other way around.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 19,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  "ADHI is inspired by the names of my parents, Anita and Dhiren, "
                  "symbolizing care, support, and inclusivity. These values drive "
                  "our mission to empower people with visual, hearing, and speech "
                  "impairments through AI.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 56),

                // Three pillar cards
                LayoutBuilder(builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 760;

                  final cards = [
                    _PillarCard(
                      icon: Icons.remove_red_eye_rounded,
                      title: "Sight",
                      stat: "1B+",
                      description:
                          "Describing the world in real time to the billion-plus people who are blind or low-vision.",
                    ),
                    _PillarCard(
                      icon: Icons.hearing_rounded,
                      title: "Hearing",
                      stat: "70M+",
                      description:
                          "Turning spoken words and urgent sounds into live, readable text for the deaf and hard of hearing.",
                    ),
                    _PillarCard(
                      icon: Icons.record_voice_over_rounded,
                      title: "Voice",
                      stat: "6.5M+",
                      description:
                          "Converting typed phrases into natural speech for people who are nonverbal or speech-impaired.",
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: cards
                          .map((c) => Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: c,
                                ),
                              ))
                          .toList(),
                    );
                  }

                  return Column(
                    children: cards
                        .map((c) => Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: c,
                            ))
                        .toList(),
                  );
                }),

                const SizedBox(height: 56),

                // Mission statement banner
                GlassPanel(
                  padding: const EdgeInsets.symmetric(
                      vertical: 44, horizontal: 36),
                  child: Column(
                    children: [
                      Icon(Icons.shield_moon_rounded,
                          color: AppColors.accentLime, size: 40),
                      const SizedBox(height: 18),
                      const Text(
                        "Accessibility is not a privilege; it is a right.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "The World Adapts To You.",
                        style: TextStyle(
                          color: AppColors.accentLime,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 56),

                const Text(
                  "How ADHI Works",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 28),

                LayoutBuilder(builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 760;

                  final steps = [
                    _StepCard(
                      number: "01",
                      title: "Capture",
                      description:
                          "Point a camera, speak, or type — ADHI listens through whichever sense you need supported.",
                    ),
                    _StepCard(
                      number: "02",
                      title: "Understand",
                      description:
                          "On-device and cloud AI models interpret speech, sound, and surroundings in real time.",
                    ),
                    _StepCard(
                      number: "03",
                      title: "Respond",
                      description:
                          "ADHI speaks, displays, or alerts — translating one sense into another, instantly.",
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      children: steps
                          .map((s) => Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                  child: s,
                                ),
                              ))
                          .toList(),
                    );
                  }

                  return Column(
                    children: steps
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(bottom: 18),
                              child: s,
                            ))
                        .toList(),
                  );
                }),

                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ---------------- PILLAR CARD ---------------- */

class _PillarCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String stat;
  final String description;

  const _PillarCard({
    required this.icon,
    required this.title,
    required this.stat,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentLime.withOpacity(0.15),
            ),
            child: Icon(icon, color: AppColors.accentLime, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            stat,
            style: TextStyle(
              color: AppColors.accentLime,
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.75),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

/* ---------------- STEP CARD ---------------- */

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              color: Colors.white.withOpacity(0.25),
              fontSize: 36,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.72),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}