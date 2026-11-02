import 'package:flutter/material.dart';
import 'models/grievance.dart';

class GrievancesTab extends StatefulWidget {
  const GrievancesTab({super.key, required this.grievances});

  final List<Grievance> grievances;

  @override
  State<GrievancesTab> createState() => _GrievancesTabState();
}

class _GrievancesTabState extends State<GrievancesTab> {
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final visibleGrievances = _filter == 'All'
        ? widget.grievances
        : widget.grievances.where((g) => g.status == _filter).toList();

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
            'My Grievances\n${widget.grievances.length} grievance(s) filed',
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
          child: visibleGrievances.isEmpty
              ? const Center(child: Text('No grievances found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: visibleGrievances.length,
                  itemBuilder: (context, index) {
                    final grievance = visibleGrievances[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(
                          grievance.department,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'ID: ${grievance.id}\n'
                          '${grievance.subject}\n'
                          'Status: ${grievance.status}',
                        ),
                        isThreeLine: true,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
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
      ],
    );
  }
}

class GrievanceDetailPage extends StatelessWidget {
  const GrievanceDetailPage({super.key, required this.grievance});

  final Grievance grievance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grievance details'),
        backgroundColor: const Color(0xFF7540B5),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _detail('Grievance ID', grievance.id),
          _detail('Status', grievance.status),
          _detail('Department', grievance.department),
          _detail('Subject', grievance.subject),
          _detail('Description', grievance.description),
          _detail('Location', grievance.location),
          _detail('Created date', _formatDate(grievance.createdAt)),
        ],
      ),
    );
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
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 5),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-${date.year} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}';
}
