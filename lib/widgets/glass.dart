import 'package:flutter/material.dart';
import '../theme.dart';

/// A reusable frosted-glass panel used across Hearing / Voice / About
/// pages so every "result" / "input" surface feels consistent and premium.
class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(28),
    this.radius = 24,
    this.borderColor,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.14),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.white.withOpacity(0.22),
          width: 1.2,
        ),
        boxShadow: boxShadow ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
      ),
      child: child,
    );
  }
}

/// Lime gradient pill button used for primary actions (Speak / Start etc).
class PremiumButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool danger;
  final bool outlined;

  const PremiumButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.danger = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white54, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        ),
      );
    }

    final colors = danger
        ? [const Color(0xFFFF6B6B), const Color(0xFFE5484D)]
        : [const Color(0xFFD4FF6B), AppColors.accentLime];

    final isDisabled = onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.5 : 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(colors: colors),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: colors.last.withOpacity(0.45),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(40),
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 18),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: const Color(0xFF062211), size: 22),
                  const SizedBox(width: 10),
                  Text(
                    label,
                    style: const TextStyle(
                      color: Color(0xFF062211),
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Large circular mic/record button with an animated pulsing ring while
/// recording, so it reads as a premium control rather than a flat
/// ElevatedButton.
class PulsingRecordButton extends StatefulWidget {
  final bool isRecording;
  final bool isLoading;
  final VoidCallback onPressed;

  const PulsingRecordButton({
    super.key,
    required this.isRecording,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  State<PulsingRecordButton> createState() => _PulsingRecordButtonState();
}

class _PulsingRecordButtonState extends State<PulsingRecordButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = widget.isRecording
        ? const Color(0xFFE5484D)
        : AppColors.accentLime;

    return GestureDetector(
      onTap: widget.isLoading ? null : widget.onPressed,
      child: SizedBox(
        width: 160,
        height: 160,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final t = _controller.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                if (widget.isRecording)
                  ...List.generate(2, (i) {
                    final delay = i * 0.5;
                    final progress = (t + delay) % 1.0;
                    return Opacity(
                      opacity: (1 - progress) * 0.5,
                      child: Container(
                        width: 110 + progress * 70,
                        height: 110 + progress * 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: activeColor,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  }),
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: widget.isRecording
                          ? [const Color(0xFFFF6B6B), const Color(0xFFE5484D)]
                          : [const Color(0xFFD4FF6B), AppColors.accentLime],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activeColor.withOpacity(0.55),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: widget.isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(
                            color: Color(0xFF062211),
                            strokeWidth: 3,
                          ),
                        )
                      : Icon(
                          widget.isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                          size: 48,
                          color: const Color(0xFF062211),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Glassmorphic text field wrapper so every text input across the app
/// (Voice Assistant, etc.) shares the same frosted look instead of a
/// plain white Material textbox.
class GlassTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLines;

  const GlassTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.14),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.22), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        cursorColor: AppColors.accentLime,
        style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.4),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 17),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(22),
        ),
      ),
    );
  }
}

/// Section heading style reused across assistant pages — bigger, bolder,
/// with a small lime accent bar to feel like a real product page.
class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = AppColors.accentLime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withOpacity(0.15),
            border: Border.all(color: iconColor.withOpacity(0.4), width: 1.5),
          ),
          child: Icon(icon, size: 56, color: iconColor),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 48,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.78),
            fontSize: 20,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
