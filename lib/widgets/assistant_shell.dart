import 'package:flutter/material.dart';
import '../theme.dart';
import 'navbar.dart';
import 'footer.dart';

/// Shared page chrome for the Vision / Hearing / Voice assistant pages.
/// Every mockup uses the same layout: white navbar, dark green page title,
/// a 3-column dashboard (tools / live output / alerts) that collapses into
/// a single column on narrow screens, and the white footer.
class AssistantShell extends StatelessWidget {
  final String title;
  final String currentRoute;
  final Widget leftSidebar;
  final Widget center;
  final Widget rightSidebar;

  const AssistantShell({
    super.key,
    required this.title,
    required this.currentRoute,
    required this.leftSidebar,
    required this.center,
    required this.rightSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomNavbar(currentRoute: currentRoute),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool isWide = constraints.maxWidth > 1000;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: 280, child: leftSidebar),
                        const SizedBox(width: 20),
                        Expanded(child: center),
                        const SizedBox(width: 20),
                        SizedBox(width: 280, child: rightSidebar),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      leftSidebar,
                      const SizedBox(height: 20),
                      center,
                      const SizedBox(height: 20),
                      rightSidebar,
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

/// Rounded green card used for every sidebar block ("Vision Tools",
/// "Environmental Context", "Alerts & Feedback", etc.)
class SidebarPanel extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SidebarPanel({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.panel,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

/// Simple icon + label row, used for static tool/setting lists.
class ToolRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const ToolRow({super.key, required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icon + label + Switch row, used for the on/off preference toggles.
class ToggleItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const ToggleItem({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accentLime,
          ),
        ],
      ),
    );
  }
}