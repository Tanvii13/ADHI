import 'package:flutter/material.dart';
import '../widgets/navbar.dart';
import '../widgets/hero_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: const [
            CustomNavbar(),
            HeroSection(),
          ],
        ),
      ),
    );
  }
}