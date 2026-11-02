final row = await supabase
    .from('grievances')
    .insert({
      'user_id': supabase.auth.currentUser!.id,
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
