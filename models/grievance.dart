class Grievance {
  const Grievance({
    required this.id,
    required this.department,
    required this.subject,
    required this.description,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String department;
  final String subject;
  final String description;
  final String location;
  final String status;
  final DateTime createdAt;
}
