final rows = await supabase
    .from('grievances')
    .select()
    .order('created_at', ascending: false);
