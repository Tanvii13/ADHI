import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'theme.dart';

void main() {
  runApp(const AdhiApp());
}

class AdhiApp extends StatelessWidget {
  const AdhiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ADHI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: const HomePage(),
    );
  }
}