import 'package:supabase_flutter/supabase_flutter.dart';

class GrievanceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> submitGrievance({
    required Object departmentId,
    required String category,
    required String subject,
    required String description,
    required String locationText,
    double? latitude,
    double? longitude,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      throw StateError('Please sign in before submitting a grievance.');
    }

    final row = await _supabase
        .from('grievances')
        .insert({
          'user_id': user.id,
          'department_id': departmentId,
          'category': category,
          'subject': subject,
          'description': description,
          'location_text': locationText,
          'latitude': latitude,
          'longitude': longitude,
        })
        .select('id, tracking_id')
        .single();

    return Map<String, dynamic>.from(row);
  }
}
