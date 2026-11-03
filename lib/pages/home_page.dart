import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:citizen_grievance_app/l10n/app_localizations.dart';

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
  //  final isKannada = Localizations.localeOf(context).languageCode == 'kn';
    final strings = AppLocalizations.of(context)!;

    final pages = [
      DashboardTab(
        userName: userName,
        onLocaleChanged: widget.onLocaleChanged,
        onNewGrievance: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const GrievanceRegistrationPage(),
            ),
          );
        },
      ),
      const GrievancesTab(),
      Center(child: Text(isKannada ? 'ಎಚ್ಚರಿಕೆಗಳು' : 'Alerts')),
      ProfileTab(
        profile: _profile,
        onSave: (updatedProfile) {
          setState(() => _profile = updatedProfile);
        },
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
