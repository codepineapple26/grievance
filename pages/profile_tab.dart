import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({
    super.key,
    required this.profile,
    required this.onSave,
  });

  final UserProfile profile;
  final ValueChanged<UserProfile> onSave;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
          decoration: const BoxDecoration(
            color: Color(0xFF7540B5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: const Text(
            'My Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Personal details',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                ],
              ),
              _detailCard([
                _detailRow(Icons.person_outline, 'Name', profile.name),
                _detailRow(Icons.phone_outlined, 'Phone', _display(profile.phone)),
                _detailRow(Icons.location_on_outlined, 'Address', _display(profile.address)),
              ]),
              const SizedBox(height: 20),
              const Text('Support', style: TextStyle(fontWeight: FontWeight.bold)),
              _menuCard([
                _menuRow(Icons.help_outline, 'FAQ & Help'),
                _menuRow(Icons.call_outlined, 'Contact Us'),
                _menuRow(Icons.chat_bubble_outline, 'Grievance Feedback'),
              ]),
              const SizedBox(height: 16),
              const Text('Information', style: TextStyle(fontWeight: FontWeight.bold)),
              _menuCard([
                _menuRow(Icons.info_outline, 'About IPGRS'),
              ]),
              const SizedBox(height: 16),
              const Text('Account', style: TextStyle(fontWeight: FontWeight.bold)),
              _menuCard([
                _menuRow(Icons.logout, 'Logout'),
                _menuRow(Icons.delete_outline, 'De-Register Account'),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final nameController = TextEditingController(text: profile.name);
    final phoneController = TextEditingController(text: profile.phone);
    final addressController = TextEditingController(text: profile.address);

    final updatedProfile = await showDialog<UserProfile>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextField(
                controller: addressController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(
                dialogContext,
                profile.copyWith(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();

    if (updatedProfile != null) onSave(updatedProfile);
  }

  static String _display(String value) =>
      value.trim().isEmpty ? 'Not added' : value;

  static Widget _detailCard(List<Widget> rows) => Container(
        decoration: _cardDecoration(),
        child: Column(children: rows),
      );

  static Widget _detailRow(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF7540B5)),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: Text(value),
    );
  }

  static Widget _menuCard(List<Widget> rows) => Container(
        decoration: _cardDecoration(),
        child: Column(children: rows),
      );

  static Widget _menuRow(IconData icon, String label) => ListTile(
        dense: true,
        leading: Icon(icon, size: 19),
        title: Text(label, style: const TextStyle(fontSize: 13)),
        trailing: const Icon(Icons.chevron_right, color: Colors.black26),
        onTap: () {},
      );

  static BoxDecoration _cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      );
}
