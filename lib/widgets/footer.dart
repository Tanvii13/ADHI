import 'package:flutter/material.dart';
import '../theme.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 40),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runSpacing: 8,
        children: [
          const Text(
            "ADHI copyright 2026",
            style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "Made with ",
                style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
              ),
              Text("❤️", style: TextStyle(fontSize: 14)),
              Text(
                " by Tanvi",
                style: TextStyle(color: AppColors.background, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}