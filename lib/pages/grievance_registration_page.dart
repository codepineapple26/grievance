import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GrievanceRegistrationPage extends StatefulWidget {
  const GrievanceRegistrationPage({super.key});

  @override
  State<GrievanceRegistrationPage> createState() =>
      _GrievanceRegistrationPageState();
}

class _GrievanceRegistrationPageState
    extends State<GrievanceRegistrationPage> {
  static const _purple = Color(0xFF7540B5);
  static const _maxBytes = 20 * 1024 * 1024;

  final _supabase = Supabase.instance.client;
  final _district = TextEditingController();
  final _taluk = TextEditingController();
  final _gramPanchayat = TextEditingController();
  final _department = TextEditingController();
  final _category = TextEditingController();
  final _description = TextEditingController();

  int _step = 0;
  bool _agreed = false;
  bool _submitting = false;
  String _locationType = 'Other Address';
  List<PlatformFile> _files = [];

  @override
  void dispose() {
    _district.dispose();
    _taluk.dispose();
    _gramPanchayat.dispose();
    _department.dispose();
    _category.dispose();
    _description.dispose();
    super.dispose();
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  void _next() {
    if (_step == 0 && !_agreed) {
      _message('Please agree to the notice before continuing.');
      return;
    }

    if (_step == 1 &&
        (_district.text.trim().isEmpty || _taluk.text.trim().isEmpty)) {
      _message('Please enter the district and taluk.');
      return;
    }

    if (_step == 2 &&
        (_department.text.trim().isEmpty || _category.text.trim().isEmpty)) {
      _message('Please enter the department and grievance category.');
      return;
    }

    setState(() => _step++);
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
      allowMultiple: true,
      withData: true,
    );

    if (result == null) return;

    final selectedFiles = [..._files, ...result.files];
    final totalBytes = selectedFiles.fold<int>(0, (total, file) {
      return total + file.size;
    });

    if (totalBytes > _maxBytes) {
      _message('All selected documents together must be 20 MB or less.');
      return;
    }

    if (result.files.any((file) => file.bytes == null)) {
      _message('Could not read one of the selected files. Please try again.');
      return;
    }

    setState(() => _files = selectedFiles);
  }

  String _contentType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) return 'application/pdf';
    if (lower.endsWith('.png')) return 'image/png';
    return 'image/jpeg';
  }

  Future<void> _submit() async {
    if (_description.text.trim().isEmpty) {
      _message('Please describe your grievance.');
      return;
    }

    final user = _supabase.auth.currentUser;
    if (user == null) {
      _message('Please sign in before submitting a grievance.');
      return;
    }

    setState(() => _submitting = true);

    try {
      final attachmentPaths = <String>[];

      for (final file in _files) {
        final safeName = file.name.replaceAll(
          RegExp(r'[^A-Za-z0-9._-]'),
          '_',
        );
        final path =
            '${user.id}/${DateTime.now().microsecondsSinceEpoch}_$safeName';

        await _supabase.storage
            .from('grievance-files')
            .uploadBinary(
              path,
              file.bytes!,
              fileOptions: FileOptions(contentType: _contentType(file.name)),
            );

        attachmentPaths.add(path);
      }

      await _supabase.from('grievances').insert({
        'user_id': user.id,
        'location_type': _locationType,
        'district': _district.text.trim(),
        'taluk': _taluk.text.trim(),
        'gram_panchayat': _gramPanchayat.text.trim(),
        'department': _department.text.trim(),
        'category': _category.text.trim(),
        'description': _description.text.trim(),
        'attachments': attachmentPaths,
        'status': 'submitted',
      });

      if (!mounted) return;

      await showDialog<void>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Grievance submitted'),
          content: const Text(
            'Your grievance has been registered successfully.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _message('Submission failed: $error');
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    String? hint,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Important Notice',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'The following matters cannot be treated as grievances: '
              'RTI matters, court-related or subjudice matters, religious '
              'matters, suggestions, and certain service matters.',
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              value: _agreed,
              onChanged: (value) => setState(() => _agreed = value ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'I agree that my grievance does not fall into any of the '
                'listed categories.',
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Location of the Grievance',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Present Address', 'Other Address'].map((location) {
                return ChoiceChip(
                  label: Text(location),
                  selected: _locationType == location,
                  onSelected: (_) => setState(() => _locationType = location),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _textField(_district, 'District *'),
            _textField(_taluk, 'Taluk *'),
            _textField(_gramPanchayat, 'Gram Panchayat'),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grievance Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text('Select the department and describe your category.'),
            const SizedBox(height: 16),
            _textField(
              _category,
              'Search for a grievance *',
              hint: 'Enter grievance category',
            ),
            _textField(
              _department,
              'Department *',
              hint: 'Enter department',
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Documents',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'PDF, PNG, and JPG files only. '
              'Maximum combined size: 20 MB.',
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload File'),
            ),
            ..._files.map(
              (file) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.insert_drive_file),
                title: Text(file.name),
                subtitle: Text(
                  '${(file.size / (1024 * 1024)).toStringAsFixed(2)} MB',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => setState(() => _files.remove(file)),
                ),
              ),
            ),
          ],
        );

      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Grievance Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Department: ${_department.text}\n'
              'Category: ${_category.text}\n'
              'Location: ${_district.text}, ${_taluk.text}',
            ),
            const SizedBox(height: 16),
            _textField(
              _description,
              'Grievance Description *',
              hint: 'Describe your grievance clearly',
              maxLines: 7,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    const stepNames = [
      'Notice',
      'Location',
      'Information',
      'Documents',
      'Details',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Grievance Registration'),
        backgroundColor: _purple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Step ${_step + 1} of 5 · ${stepNames[_step]}'),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        height: 5,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: index <= _step
                              ? _purple
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildStep(),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed: _submitting
                        ? null
                        : () {
                            if (_step == 0) {
                              Navigator.pop(context);
                            } else {
                              setState(() => _step--);
                            }
                          },
                    child: Text(_step == 0 ? 'Cancel' : 'Previous'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _purple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _submitting
                          ? null
                          : (_step == 4 ? _submit : _next),
                      child: Text(
                        _submitting
                            ? 'Submitting…'
                            : (_step == 4 ? 'Review & Submit' : 'Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
