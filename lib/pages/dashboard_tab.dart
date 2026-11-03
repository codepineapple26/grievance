import 'package:flutter/material.dart';
import 'package:citizen_grievance_app/l10n/app_localizations.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({
    super.key,
    required this.userName,
    required this.onNewGrievance,
    required this.onLocaleChanged,
  });

  final String userName;
  final VoidCallback onNewGrievance;
  final ValueChanged<Locale> onLocaleChanged;

  static const purple = Color(0xFF7540B5);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final languageCode = Localizations.localeOf(context).languageCode;

    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
      children: [
        Text(
          strings.hello(userName),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              const Icon(Icons.translate, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  strings.language,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              _languageButton(
                'English',
                selected: languageCode == 'en',
                onTap: () => onLocaleChanged(const Locale('en')),
              ),
              const SizedBox(width: 6),
              _languageButton(
                'ಕನ್ನಡ',
                selected: languageCode == 'kn',
                onTap: () => onLocaleChanged(const Locale('kn')),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        InkWell(
          onTap: onNewGrievance,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF8750C6), Color(0xFF6333A5)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: purple.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFFFC94A),
                  child: Icon(Icons.add, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.newGrievanceRegistration,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.fileNewComplaint,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const CircleAvatar(
                  backgroundColor: Color(0xFFFFC94A),
                  child: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strings.grievanceStatus,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Text(strings.viewAll),
            ),
          ],
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _StatusCard(
              icon: Icons.access_time,
              count: '0',
              label: strings.registeredForScrutiny,
              color: const Color(0xFF4B83D1),
            ),
            _StatusCard(
              icon: Icons.sync,
              count: '0',
              label: strings.inProgress,
              color: const Color(0xFFD4A51C),
            ),
            _StatusCard(
              icon: Icons.inventory_2_outlined,
              count: '0',
              label: strings.closed,
              color: const Color(0xFF777777),
            ),
            _StatusCard(
              icon: Icons.check_circle_outline,
              count: '3',
              label: strings.resolved,
              color: const Color(0xFF39A76A),
            ),
          ],
        ),
      ],
    );
  }

  static Widget _languageButton(
    String label, {
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? purple : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  static BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x12000000),
          blurRadius: 6,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String count;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const Spacer(),
          Text(
            count,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
