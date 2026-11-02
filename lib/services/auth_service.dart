class AuthService {
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    // Demo only. Connect this method to your backend for real authentication.
    await Future.delayed(const Duration(milliseconds: 500));

    final namePart = email.split('@').first;
    return namePart.isEmpty ? 'User' : namePart;
  }
}
