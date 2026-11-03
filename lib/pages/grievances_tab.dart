import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:citizen_grievance_app/l10n/app_localizations.dart';

class GrievancesTab extends StatefulWidget {
  const GrievancesTab({super.key});

  @override
  State<GrievancesTab> createState() => _GrievancesTabState();
}

class _GrievancesTabState extends State<GrievancesTab> {
  String _filter = 'All';
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _grievances = [];

  @override
  void initState() {
    super.initState();
    _loadGrievances();
  }

  Future<void> _loadGrievances() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final client = Supabase.instance.client;
      final user = client.auth.currentUser;

      if (user == null) {
        throw StateError('Please sign in to view your grievances.');
      }

      final data = await client
          .from('grievances')
          .select()
          .eq('user_id', user.id);

      if (!mounted) return;

      setState(() {
        _grievances = List<Map<String, dynamic>>.from(data);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _text(Object? value, {String fallback = '—'}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  String _status(Map<String, dynamic> grievance) =>
      _text(grievance['status'], fallback: 'Registered');

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final visibleGrievances = _filter == 'All'
        ? _grievances
        : _grievances
            .where(
              (grievance) =>
                  _status(grievance).toLowerCase() == _filter.toLowerCase(),
            )
            .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
          decoration: const BoxDecoration(
            color: Color(0xFF7540B5),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          child: Text(
            'My Grievances\n${_grievances.length} grievance(s) filed',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 54,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            children: ['All', 'Registered', 'In Progress', 'Resolved']
                .map(
                  (status) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: _filter == status,
                      onSelected: (_) => setState(() => _filter = status),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadGrievances,
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : visibleGrievances.isEmpty
                      ? const Center(child: Text('No grievances found'))
                      : RefreshIndicator(
                          onRefresh: _loadGrievances,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: visibleGrievances.length,
                            itemBuilder: (context, index) {
                              final grievance = visibleGrievances[index];
                              final id = _text(
                                grievance['tracking_id'] ?? grievance['id'],
                              );
                              final department = _text(
                                grievance['department_name'] ??
                                    grievance['department'],
                                fallback: 'Department ${_text(grievance['department_id'])}',
                              );

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.only(bottom: 12),
                                child: ListTile(
                                  title: Text(
                                    department,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'ID: $id\n'
                                    '${_text(grievance['subject'])}\n'
                                    'Status: ${_status(grievance)}',
                                  ),
                                  isThreeLine: true,
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => GrievanceDetailPage(
                                          grievance: grievance,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
        ),
      ],
    );
  }
}

class GrievanceDetailPage extends StatelessWidget {
  const GrievanceDetailPage({
    super.key,
    required this.grievance,
  });

  final Map<String, dynamic> grievance;

  String _text(Object? value, {String fallback = '—'}) {
    final text = value?.toString().trim();
    return text == null || text.isEmpty ? fallback : text;
  }

  String _formatDate(Object? value) {
    final date = DateTime.tryParse(value?.toString() ?? '');
    if (date == null) return _text(value);

    final localDate = date.toLocal();
    return '${localDate.day.toString().padLeft(2, '0')}-'
        '${localDate.month.toString().padLeft(2, '0')}-'
        '${localDate.year} '
        '${localDate.hour.toString().padLeft(2, '0')}:'
        '${localDate.minute.toString().padLeft(2, '0')}';
  }

  Widget _detail(String label, String value) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final department = grievance['department_name'] ??
        grievance['department'] ??
        'Department ${grievance['department_id'] ?? '—'}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance details'),
        backgroundColor: const Color(0xFF7540B5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _detail(
            'Grievance ID',
            _text(grievance['tracking_id'] ?? grievance['id']),
          ),
          _detail('Status', _text(grievance['status'], fallback: 'Registered')),
          _detail('Department', department.toString()),
          _detail('Category', _text(grievance['category'])),
          _detail('Subject', _text(grievance['subject'])),
          _detail('Description', _text(grievance['description'])),
          _detail('Location', _text(grievance['location_text'])),
          _detail('Created date', _formatDate(grievance['created_at'])),
        ],
      ),
    );
  }
}
