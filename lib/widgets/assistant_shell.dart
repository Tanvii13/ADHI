import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String currentRoute;

  const AppTopBar({
    super.key,
    required this.currentRoute,
  });

  Widget navItem(
      BuildContext context,
      String title,
      String route,
      bool active,
      ) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Text(
          title,
          style: TextStyle(
            color: const Color(0xFF004D26),
            fontSize: 18,
            fontWeight:
            active ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [

          Image.asset(
            "assets/logo.jpg",
            width: 45,
            height: 45,
          ),

          const SizedBox(width: 12),

          const Text(
            "ADHI",
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D26),
            ),
          ),

          const Spacer(),

          navItem(
            context,
            "Home",
            "/",
            currentRoute == "/",
          ),

          navItem(
            context,
            "Hearing Assistant",
            "/hearing",
            currentRoute == "/hearing",
          ),

          navItem(
            context,
            "Vision Assistant",
            "/vision",
            currentRoute == "/vision",
          ),

          navItem(
            context,
            "Voice Assistant",
            "/speech",
            currentRoute == "/speech",
          ),

          navItem(
            context,
            "More",
            "/",
            false,
          ),

          navItem(
            context,
            "About",
            "/about",
            currentRoute == "/about",
          ),
        ],
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
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: [

          const Text(
            "©2026 ADHI",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D26),
            ),
          ),

          const Spacer(),

          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: "Made with ",
                  style: TextStyle(
                    color: Color(0xFF004D26),
                  ),
                ),
                TextSpan(
                  text: "❤️",
                ),
                TextSpan(
                  text: " by Tanvi",
                  style: TextStyle(
                    color: Color(0xFF004D26),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class AppPageShell extends StatelessWidget {
  final String currentRoute;
  final Widget body;

  const AppPageShell({
    super.key,
    required this.currentRoute,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF004D26),

      body: Column(
        children: [

          AppTopBar(
            currentRoute: currentRoute,
          ),

          Expanded(
            child: SingleChildScrollView(
              child: body,
            ),
          ),

          const AppFooter(),
        ],
      ),
    );
  }
}