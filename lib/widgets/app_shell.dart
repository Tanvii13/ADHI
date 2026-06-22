import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String currentRoute;

  const AppTopBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1000;

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

          if (isDesktop) ...[
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
          ] else ...[
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Color(0xFF014421),
                    size: 32,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
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

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF014421),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
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
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white24, height: 1),
            const SizedBox(height: 20),
            _drawerTile(context, 'Home', '/', Icons.home_rounded),
            _drawerTile(
              context,
              'Hearing Assistant',
              '/hearing',
              Icons.hearing_rounded,
            ),
            _drawerTile(
              context,
              'Vision Assistant',
              '/vision',
              Icons.visibility_rounded,
            ),
            _drawerTile(
              context,
              'Voice Assistant',
              '/speech',
              Icons.record_voice_over_rounded,
            ),
            _drawerTile(context, 'About', '/about', Icons.info_rounded),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(24.0),
              child: Text(
                "©2026 ADHI",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerTile(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    final selected = currentRoute == route;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: () {
          Navigator.pop(context); // Close the drawer
          if (currentRoute != route) {
            Navigator.pushNamed(context, route);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected
                ? Colors.white.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? Colors.white24 : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: selected ? const Color(0xFFB7E63E) : Colors.white,
                size: 24,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: selected ? const Color(0xFFB7E63E) : Colors.white,
                  fontSize: 17,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ],
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
      endDrawer: AppDrawer(currentRoute: currentRoute),
      body: Column(
        children: [
          navBar,
          Expanded(child: body),
          footer,
        ],
      ),
    );
  }
}
