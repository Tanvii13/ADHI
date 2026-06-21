import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String currentRoute;

  const AppTopBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                const Text(
                  'ADHI',
                  style: TextStyle(
                    color: Color(0xFF014421),
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          _navButton(context, 'Home', '/', currentRoute),
          _navButton(context, 'Hearing Assistant', '/hearing', currentRoute),
          _navButton(context, 'Vision Assistant', '/vision', currentRoute),
          _navButton(context, 'Voice Assistant', '/speech', currentRoute),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "More",
              style: TextStyle(
                color: Color(0xFF014421),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          _navButton(context, 'About', '/about', currentRoute),
        ],
      ),
    );
  }

  Widget _navButton(
    BuildContext context,
    String title,
    String route,
    String current,
  ) {
    final selected = current == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF014421),
            fontSize: 18,
            fontWeight: selected ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: const [
          Text(
            "©2026 ADHI",
            style: TextStyle(
              color: Color(0xFF014421),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Text(
            "Made with ❤️ by Tanvi",
            style: TextStyle(
              color: Color(0xFF014421),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class AppPageShell extends StatelessWidget {
  final Widget body;
  final String currentRoute;

  const AppPageShell({
    super.key,
    required this.body,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF014421),

      body: Column(
        children: [
          AppTopBar(currentRoute: currentRoute),

          Expanded(child: SingleChildScrollView(child: body)),

          const AppFooter(),
        ],
      ),
    );
  }
}
