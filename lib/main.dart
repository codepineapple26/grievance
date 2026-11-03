import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/app_localizations.dart';
import 'pages/home_page.dart';
import 'pages/sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://mbpwyvnlavauwfwfuylv.supabase.co',
    publishableKey: 'YOUR_SUPABASE_PUBLISHABLE_KEY',
  );

  runApp(const GrievanceApp());
}

final supabase = Supabase.instance.client;

class GrievanceApp extends StatefulWidget {
  const GrievanceApp({super.key});

  @override
  State<GrievanceApp> createState() => _GrievanceAppState();
}

class _GrievanceAppState extends State<GrievanceApp> {
  Locale _locale = const Locale('en');

  void _setLocale(Locale locale) {
    setState(() => _locale = locale);
  }

  Widget _startPage() {
    final user = supabase.auth.currentSession?.user;

    if (user == null) {
      return const SignInPage();
    }

    return HomePage(
      userName: user.email?.split('@').first ?? 'Citizen',
      onLocaleChanged: _setLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grievance App',
      debugShowCheckedModeBanner: false,
      locale: _locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF174A8B),
        ),
      ),
      home: _startPage(),
    );
  }
}
