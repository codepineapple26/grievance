import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mbpwyvnlavauwfwfuylv.supabase.co',
    publishableKey: 'sb_publishable_DCE0OoJWP5dIlHZIKZwKJQ_xD-Gje49',
  );

  runApp(const GrievanceApp());
}

final supabase = Supabase.instance.client;

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
