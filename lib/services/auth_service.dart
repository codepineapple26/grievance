import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await Supabase.instance.client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) {
      throw Exception('Sign-in did not return a user.');
    }

    final metadata = user.userMetadata;
    final name = metadata?['full_name'] ?? metadata?['name'];

    if (name is String && name.trim().isNotEmpty) {
      return name;
    }

    return user.email?.split('@').first ?? 'User';
  }
}
