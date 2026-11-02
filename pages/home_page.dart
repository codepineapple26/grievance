import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav.dart';
import 'dashboard_tab.dart';
import 'grievances_tab.dart';
import 'profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userName});

  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardTab(
        userName: widget.userName,
        onNewGrievance: _showNewGrievanceMessage,
      ),
      const GrievancesTab(),
      const Center(child: Text('Alerts')),
      const ProfileTab(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(child: pages[_selectedIndex]),
      bottomNavigationBar: AppBottomNav(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }

  void _showNewGrievanceMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connect this button to your grievance form.')),
    );
  }
}
