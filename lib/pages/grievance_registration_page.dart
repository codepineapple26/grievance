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
  final _subject = TextEditingController();
  final _description = TextEditingController();

  int _step = 0;
  bool _agreed = false;
  bool _submitting = false;
  String _locationType = 'Other Address';
  List<PlatformFile> _files = [];

  List<Map<String, dynamic>> districts = [];
  List<Map<String, dynamic>> taluks = [];
  List<Map<String, dynamic>> gramPanchayats = [];
  List<Map<String, dynamic>> villages = [];

  int? selectedDistrictId;
  int? selectedTalukId;
  int? selectedGramPanchayatId;
  int? selectedVillageId;

  String? selectedDistrictName;
  String? selectedTalukName;
  String? selectedGramPanchayatName;
  String? selectedVillageName;

  List<Map<String, dynamic>> departments = [];
  List<Map<String, dynamic>> subDepartments = [];
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> grievanceTypes = [];
  List<Map<String, dynamic>> grievanceCategories = [];
  List<Map<String, dynamic>> grievanceSubCategories = [];

  int? selectedDepartmentId;
  int? selectedSubDepartmentId;
  int? selectedServiceId;
  int? selectedGrievanceTypeId;
  int? selectedGrievanceCategoryId;
  int? selectedGrievanceSubCategoryId;

  String? selectedDepartmentName;
  String? selectedSubDepartmentName;
  String? selectedServiceName;
  String? selectedGrievanceTypeName;
  String? selectedGrievanceCategoryName;
  String? selectedGrievanceSubCategoryName;

  @override
  void initState() {
    super.initState();
    _loadInitialOptions();
  }

  Future<void> _loadInitialOptions() async {
    await Future.wait([
      _loadDistricts(),
      _loadDepartments(),
    ]);
  }

  Future<void> _loadDistricts() async {
    try {
      final rows = await _supabase
          .from('districts')
          .select('id, name')
          .eq('is_active', true)
          .order('name');

      if (!mounted) return;
      setState(() {
        districts = List<Map<String, dynamic>>.from(rows);
      });
    } catch (error) {
      if (mounted) _message('Could not load districts: $error');
    }
  }

  Future<void> _loadDepartments() async {
    try {
      final rows = await _supabase
          .from('departments')
          .select('id, name')
          .eq('is_active', true)
          .order('name');

      if (!mounted) return;
      setState(() {
        departments = List<Map<String, dynamic>>.from(rows);
      });
    } catch (error) {
      if (mounted) _message('Could not load departments: $error');
    }
  }

  Future<List<Map<String, dynamic>>> loadOptions(
    String table,
    String parentColumn,
    int parentId,
  ) async {
    try {
      final rows = await _supabase
          .from(table)
          .select('id, name')
          .eq(parentColumn, parentId)
          .eq('is_active', true)
          .order('name');

      return List<Map<String, dynamic>>.from(rows);
    } catch (error) {
      if (mounted) _message('Could not load options: $error');
      return [];
    }
  }

  String _nameFor(List<Map<String, dynamic>> rows, int id) {
    return rows.firstWhere((row) => row['id'] == id)['name'] as String;
  }

  Future<void> _onDistrictChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(districts, id);

    setState(() {
      selectedDistrictId = id;
      selectedDistrictName = name;
      selectedTalukId = null;
      selectedTalukName = null;
      selectedGramPanchayatId = null;
      selectedGramPanchayatName = null;
      selectedVillageId = null;
      selectedVillageName = null;
      taluks = [];
      gramPanchayats = [];
      villages = [];
    });

    final rows = await loadOptions('taluks', 'district_id', id);
    if (!mounted) return;
    setState(() => taluks = rows);
  }

  Future<void> _onTalukChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(taluks, id);

    setState(() {
      selectedTalukId = id;
      selectedTalukName = name;
      selectedGramPanchayatId = null;
      selectedGramPanchayatName = null;
      selectedVillageId = null;
      selectedVillageName = null;
      gramPanchayats = [];
      villages = [];
    });

    final rows = await loadOptions('gram_panchayats', 'taluk_id', id);
    if (!mounted) return;
    setState(() => gramPanchayats = rows);
  }

  Future<void> _onGramPanchayatChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(gramPanchayats, id);

    setState(() {
      selectedGramPanchayatId = id;
      selectedGramPanchayatName = name;
      selectedVillageId = null;
      selectedVillageName = null;
      villages = [];
    });

    final rows = await loadOptions('villages', 'gram_panchayat_id', id);
    if (!mounted) return;
    setState(() => villages = rows);
  }

  void _onVillageChanged(int? id) {
    if (id == null) return;
    setState(() {
      selectedVillageId = id;
      selectedVillageName = _nameFor(villages, id);
    });
  }

  Future<void> _onDepartmentChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(departments, id);

    setState(() {
      selectedDepartmentId = id;
      selectedDepartmentName = name;
      selectedSubDepartmentId = null;
      selectedSubDepartmentName = null;
      selectedServiceId = null;
      selectedServiceName = null;
      selectedGrievanceTypeId = null;
      selectedGrievanceTypeName = null;
      selectedGrievanceCategoryId = null;
      selectedGrievanceCategoryName = null;
      selectedGrievanceSubCategoryId = null;
      selectedGrievanceSubCategoryName = null;
      subDepartments = [];
      services = [];
      grievanceTypes = [];
      grievanceCategories = [];
      grievanceSubCategories = [];
    });

    final rows = await loadOptions('sub_departments', 'department_id', id);
    if (!mounted) return;
    setState(() => subDepartments = rows);
  }

  Future<void> _onSubDepartmentChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(subDepartments, id);

    setState(() {
      selectedSubDepartmentId = id;
      selectedSubDepartmentName = name;
      selectedServiceId = null;
      selectedServiceName = null;
      selectedGrievanceTypeId = null;
      selectedGrievanceTypeName = null;
      selectedGrievanceCategoryId = null;
      selectedGrievanceCategoryName = null;
      selectedGrievanceSubCategoryId = null;
      selectedGrievanceSubCategoryName = null;
      services = [];
      grievanceTypes = [];
      grievanceCategories = [];
      grievanceSubCategories = [];
    });

    final rows = await loadOptions('services', 'sub_department_id', id);
    if (!mounted) return;
    setState(() => services = rows);
  }

  Future<void> _onServiceChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(services, id);

    setState(() {
      selectedServiceId = id;
      selectedServiceName = name;
      selectedGrievanceTypeId = null;
      selectedGrievanceTypeName = null;
      selectedGrievanceCategoryId = null;
      selectedGrievanceCategoryName = null;
      selectedGrievanceSubCategoryId = null;
      selectedGrievanceSubCategoryName = null;
      grievanceTypes = [];
      grievanceCategories = [];
      grievanceSubCategories = [];
    });

    final rows = await loadOptions('grievance_types', 'service_id', id);
    if (!mounted) return;
    setState(() => grievanceTypes = rows);
  }

  Future<void> _onGrievanceTypeChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(grievanceTypes, id);

    setState(() {
      selectedGrievanceTypeId = id;
      selectedGrievanceTypeName = name;
      selectedGrievanceCategoryId = null;
      selectedGrievanceCategoryName = null;
      selectedGrievanceSubCategoryId = null;
      selectedGrievanceSubCategoryName = null;
      grievanceCategories = [];
      grievanceSubCategories = [];
    });

    final rows = await loadOptions('grievance_categories', 'grievance_type_id', id);
    if (!mounted) return;
    setState(() => grievanceCategories = rows);
  }

  Future<void> _onGrievanceCategoryChanged(int? id) async {
    if (id == null) return;
    final name = _nameFor(grievanceCategories, id);

    setState(() {
      selectedGrievanceCategoryId = id;
      selectedGrievanceCategoryName = name;
      selectedGrievanceSubCategoryId = null;
      selectedGrievanceSubCategoryName = null;
      grievanceSubCategories = [];
    });

    final rows = await loadOptions(
      'grievance_sub_categories',
      'grievance_category_id',
      id,
    );
    if (!mounted) return;
    setState(() => grievanceSubCategories = rows);
  }

  void _onGrievanceSubCategoryChanged(int? id) {
    if (id == null) return;
    setState(() {
      selectedGrievanceSubCategoryId = id;
      selectedGrievanceSubCategoryName = _nameFor(grievanceSubCategories, id);
    });
  }

  @override
  void dispose() {
    _subject.dispose();
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
        (selectedDistrictId == null || selectedTalukId == null)) {
      _message('Please select the district and taluk.');
      return;
    }

    if (_step == 2 &&
        (selectedDepartmentId == null ||
            selectedSubDepartmentId == null ||
            selectedServiceId == null ||
            selectedGrievanceTypeId == null ||
            selectedGrievanceCategoryId == null ||
            selectedGrievanceSubCategoryId == null ||
            _subject.text.trim().isEmpty)) {
      _message('Please complete the grievance selections and subject.');
      return;
    }

    setState(() => _step++);
  }

  Future<void> _pickFiles() async {
  final pickedFiles = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg'],
  );

  if (pickedFiles.isEmpty) return;

  final List<PlatformFile> selectedFiles = [
    ..._files,
    ...pickedFiles,
  ];

  var totalBytes = 0;
  for (final file in selectedFiles) {
    totalBytes += await file.length();
  }

  if (totalBytes > _maxBytes) {
    _message('All selected documents together must be 20 MB or less.');
    return;
  }

  setState(() => _files = selectedFiles);
}


FutureBuilder<String>(
  future: _formatFileSize(file),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Text('Calculating size…');
    }

    if (snapshot.hasError) {
      return const Text('Size unavailable');
    }

    return Text(snapshot.data ?? 'Size unavailable');
  },
)



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
    final uploadedPaths = <String>[];

    try {
      final locationText = [
        'Type: $_locationType',
        if (selectedDistrictName != null) 'District: $selectedDistrictName',
        if (selectedTalukName != null) 'Taluk: $selectedTalukName',
        if (selectedGramPanchayatName != null)
          'Gram Panchayat: $selectedGramPanchayatName',
        if (selectedVillageName != null) 'Village: $selectedVillageName',
      ].join(', ');

      final grievance = await _supabase
          .from('grievances')
          .insert({
            'tracking_id': 'GRV-${DateTime.now().microsecondsSinceEpoch}',
            'user_id': user.id,
            'department_id': selectedDepartmentId,
            'sub_department_id': selectedSubDepartmentId,
            'service_id': selectedServiceId,
            'grievance_type_id': selectedGrievanceTypeId,
            'grievance_category_id': selectedGrievanceCategoryId,
            'grievance_sub_category_id': selectedGrievanceSubCategoryId,
            'category': selectedGrievanceCategoryName,
            'subject': _subject.text.trim(),
            'description': _description.text.trim(),
            'location_text': locationText,
            'district_id': selectedDistrictId,
            'taluk_id': selectedTalukId,
            'gram_panchayat_id': selectedGramPanchayatId,
            'village_id': selectedVillageId,
            'latitude': null,
            'longitude': null,
            'status': 'submitted',
          })
          .select('id')
          .single();

      final grievanceId = grievance['id'] as String;
      final attachmentRows = <Map<String, dynamic>>[];

      for (final file in _files) {
        final safeName = file.name.replaceAll(
          RegExp(r'[^A-Za-z0-9._-]'),
          '_',
        );
        final path =
            '${user.id}/${DateTime.now().microsecondsSinceEpoch}_$safeName';
        final bytes = await file.readAsBytes();
        await _supabase.storage.from('grievance-files').uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(contentType: _contentType(file.name)),
        );

        uploadedPaths.add(path);
        attachmentRows.add({
          'grievance_id': grievanceId,
          'object_path': path,
          'file_name': file.name,
        });
      }

      if (attachmentRows.isNotEmpty) {
        await _supabase
            .from('grievance_attachments')
            .insert(attachmentRows);
      }

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
      if (uploadedPaths.isNotEmpty) {
        try {
          await _supabase.storage.from('grievance-files').remove(uploadedPaths);
        } catch (_) {
          // Keep the original submission error as the message.
        }
      }

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

  Widget _dropdown({
    required String label,
    required int? value,
    required List<Map<String, dynamic>> options,
    required ValueChanged<int?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<int>(
        value: value,
        decoration: InputDecoration(labelText: label),
        items: options.map((row) {
          return DropdownMenuItem<int>(
            value: row['id'] as int,
            child: Text(row['name'] as String),
          );
        }).toList(),
        onChanged: onChanged,
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
              onChanged: (value) =>
                  setState(() => _agreed = value ?? false),
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
                  onSelected: (_) =>
                      setState(() => _locationType = location),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            _dropdown(
              label: 'District *',
              value: selectedDistrictId,
              options: districts,
              onChanged: (id) {
                _onDistrictChanged(id);
              },
            ),

            if (selectedDistrictId != null)
              _dropdown(
                label: 'Taluk *',
                value: selectedTalukId,
                options: taluks,
                onChanged: (id) {
                  _onTalukChanged(id);
                },
              ),

            if (selectedTalukId != null)
              _dropdown(
                label: 'Gram Panchayat',
                value: selectedGramPanchayatId,
                options: gramPanchayats,
                onChanged: (id) {
                  _onGramPanchayatChanged(id);
                },
              ),

            if (selectedGramPanchayatId != null)
              _dropdown(
                label: 'Village',
                value: selectedVillageId,
                options: villages,
                onChanged: (id) {
                  _onVillageChanged(id);
                },
              ),
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
            const Text('Select the department and grievance details.'),
            const SizedBox(height: 16),

            _dropdown(
              label: 'Department *',
              value: selectedDepartmentId,
              options: departments,
              onChanged: (id) {
                _onDepartmentChanged(id);
              },
            ),

            if (selectedDepartmentId != null)
              _dropdown(
                label: 'Sub Department *',
                value: selectedSubDepartmentId,
                options: subDepartments,
                onChanged: (id) {
                  _onSubDepartmentChanged(id);
                },
              ),

            if (selectedSubDepartmentId != null)
              _dropdown(
                label: 'Service *',
                value: selectedServiceId,
                options: services,
                onChanged: (id) {
                  _onServiceChanged(id);
                },
              ),

            if (selectedServiceId != null)
              _dropdown(
                label: 'Grievance *',
                value: selectedGrievanceTypeId,
                options: grievanceTypes,
                onChanged: (id) {
                  _onGrievanceTypeChanged(id);
                },
              ),

            if (selectedGrievanceTypeId != null)
              _dropdown(
                label: 'Grievance Category *',
                value: selectedGrievanceCategoryId,
                options: grievanceCategories,
                onChanged: (id) {
                  _onGrievanceCategoryChanged(id);
                },
              ),

            if (selectedGrievanceCategoryId != null)
              _dropdown(
                label: 'Grievance Subcategory *',
                value: selectedGrievanceSubCategoryId,
                options: grievanceSubCategories,
                onChanged: (id) {
                  _onGrievanceSubCategoryChanged(id);
                },
              ),

            _textField(
              _subject,
              'Subject *',
              hint: 'Enter a short subject',
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
                subtitle: Text(_formatFileSize(file)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() => _files.remove(file));
                  },
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
              'Grievance Details / Review',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Department: ${selectedDepartmentName ?? ''}\n'
              'Sub Department: ${selectedSubDepartmentName ?? ''}\n'
              'Service: ${selectedServiceName ?? ''}\n'
              'Grievance: ${selectedGrievanceTypeName ?? ''}\n'
              'Category: ${selectedGrievanceCategoryName ?? ''}\n'
              'Subcategory: ${selectedGrievanceSubCategoryName ?? ''}\n'
              'Location: ${selectedDistrictName ?? ''}, '
              '${selectedTalukName ?? ''}, '
              '${selectedGramPanchayatName ?? ''}, '
              '${selectedVillageName ?? ''}',
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
