import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/user_profile.dart';
import '../widgets/app_bottom_nav.dart';
import 'dashboard_tab.dart';
import 'grievances_tab.dart';
import 'profile_tab.dart';
import 'grievance_registration_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.userName,
    required this.onLocaleChanged,
  });

  final String userName;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late UserProfile _profile;

  Locale _locale = const Locale('en');

  // 🛠️ FIX: Triggers both the local state and global layout update
  void _setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    widget.onLocaleChanged(locale); // Clears unused warning by propagating update up
  }

  String get userName {
    final user = Supabase.instance.client.auth.currentUser;
    final metadata = user?.userMetadata;
    final name = metadata?['full_name'] ?? metadata?['name'];

    if (name is String && name.trim().isNotEmpty) {
      return name;
    }

    return user?.email?.split('@').first ?? widget.userName;
  }

  @override
  void initState() {
    super.initState();
    _profile = UserProfile(
      name: widget.userName,
      phone: '',
      address: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🛠️ Localization map helper based on the active _locale
    final isKannada = _locale.languageCode == 'kn';

    final pages = [
      DashboardTab(
        userName: userName,
        onLocaleChanged: _setLocale, // 🛠️ FIX: Pass internal state modifier to clear warning
        onNewGrievance: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const GrievanceRegistrationPage(),
            ),
          );
        },
      ),
      const GrievancesTab(),
      Center(child: Text(isKannada ? 'ಎಚ್ಚರಿಕೆಗಳು' : 'Alerts')), // Dynamic language text
      ProfileTab(
        profile: _profile,
        onSave: (updatedProfile) {
          setState(() => _profile = updatedProfile);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        title: Text(isKannada ? 'ಮುಖಪುಟ' : 'Home'),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          // Language switcher button inside the AppBar actions row
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language, color: Color(0xFF174A8B)),
            onSelected: _setLocale,
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('kn'),
                child: Text('ಕನ್ನಡ (Kannada)'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
