import 'package:flutter/material.dart';
import '../theme.dart';

class CustomNavbar extends StatelessWidget {
  const CustomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 25,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Icon(
                Icons.accessibility_new,
                color: AppColors.darkGreen,
                size: 40,
              ),

              const SizedBox(width: 10),

              const Text(
                "ADHI",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          Row(
            children: [
              navItem("Mission"),
              navItem("Vision"),
              navItem("Hearing"),
              navItem("Speech"),
              navItem("Impact"),

              const SizedBox(width: 25),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Try ADHI",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
    );
  }
}