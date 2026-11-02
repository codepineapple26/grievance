import 'package:flutter/material.dart';
import 'lib/models/grievance.dart';
import 'lib/models/user_profile.dart';
import 'lib/widgets/app_bottom_nav.dart';
import 'lib/pages/dashboard_tab.dart';
import 'lib/pages/grievances_tab.dart';
import 'lib/pages/profile_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.userName});

  final String userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late UserProfile _profile;

  // Sample records for the UI. Replace these with records loaded for this user.
  final List<Grievance> _grievances = [
    Grievance(
      id: '2669802',
      department: 'Revenue Department',
      subject: 'Request for document correction',
      description: 'Please review and correct the details in my submitted record.',
      location: 'Bengaluru',
      status: 'Resolved',
      createdAt: DateTime(2025, 9, 19, 8, 8),
    ),
    Grievance(
      id: '2666407',
      department: 'Rural Development and Panchayath Raj Department',
      subject: 'Road repair request',
      description: 'The road near my area needs repair.',
      location: 'Mysuru',
      status: 'In Progress',
      createdAt: DateTime(2025, 9, 6, 18, 29),
    ),
    Grievance(
      id: '2662223',
      department: 'Urban Development Department',
      subject: 'Street light issue',
      description: 'The street light near my home is not working.',
      location: 'Bengaluru',
      status: 'Registered',
      createdAt: DateTime(2025, 9, 6, 16, 34),
    ),
  ];

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
    final pages = [
      DashboardTab(
        userName: _profile.name,
        onNewGrievance: () {},
      ),
      GrievancesTab(grievances: _grievances),
      const Center(child: Text('Alerts')),
      ProfileTab(
        profile: _profile,
        onSave: (updatedProfile) {
          setState(() => _profile = updatedProfile);
        },
      ),
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
}
