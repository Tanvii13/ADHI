import 'package:flutter/material.dart';

/// The white top navigation bar used on every single page of ADHI
/// (home, vision, hearing, speech, about). Extracted so it's defined once
/// and can never drift out of sync between pages.
class AppTopBar extends StatelessWidget {
  final String currentRoute;
  const AppTopBar({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: LayoutBuilder(builder: (context, constraints) {
        final logoRow = Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamedAndRemoveUntil(
                  context, '/', (route) => false),
              child: Image.asset('assets/logo.jpg',
                  height: 35,
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.circle, color: Color(0xFF13502B))),
            ),
            const SizedBox(width: 12),
            const Text('ADHI',
                style: TextStyle(
                    color: Color(0xFF0F3E21),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2)),
          ],
        );

        final navRow = Wrap(
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _NavLink('Home',
                isSelected: currentRoute == '/',
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, '/', (route) => false)),
            _NavLink('Hearing Assistant',
                isSelected: currentRoute == '/hearing',
                onTap: () => Navigator.pushNamed(context, '/hearing')),
            _NavLink('Vision Assistant',
                isSelected: currentRoute == '/vision',
                onTap: () => Navigator.pushNamed(context, '/vision')),
            _NavLink('Voice Assistant',
                isSelected: currentRoute == '/speech',
                onTap: () => Navigator.pushNamed(context, '/speech')),
            _NavLink('About',
                isSelected: currentRoute == '/about',
                onTap: () => Navigator.pushNamed(context, '/about')),
          ],
        );

        if (constraints.maxWidth > 760) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [logoRow, navRow],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [logoRow, const SizedBox(height: 12), navRow],
        );
      }),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  const _NavLink(this.title, {this.isSelected = false, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.title,
            style: TextStyle(
              color: (widget.isSelected || _hovering)
                  ? const Color(0xFF13502B)
                  : Colors.black87,
              fontSize: 15,
              fontWeight:
                  widget.isSelected ? FontWeight.bold : FontWeight.w500,
              decoration:
                  _hovering ? TextDecoration.underline : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }
}

/// The white footer bar used on every page. The copyright year is computed
/// live from the device clock so it's never manually out of date.
class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        children: [
          Text('ADHI copyright $year',
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Made with ',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              const Text('❤️', style: TextStyle(fontSize: 14)),
              const Text(' by Tanvi',
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Standard page wrapper: white topbar, dark-green scrollable body, white
/// footer. Every assistant page uses this so none of them look "bare".
class AppPageShell extends StatelessWidget {
  final String currentRoute;
  final Widget body;
  const AppPageShell({super.key, required this.currentRoute, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF062211),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppTopBar(currentRoute: currentRoute),
            body,
            const AppFooter(),
          ],
        ),
      ),
    );
  }
}
