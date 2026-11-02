import 'package:flutter/material.dart';
import 'pages/sign_in_page.dart';

void main() {
  runApp(const GrievanceApp());
}

class GrievanceApp extends StatelessWidget {
  const GrievanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grievance App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174A8B),
        ),
      ),
      home: const SignInPage(),
    );
  }
}
