class UserProfile {
  const UserProfile({
    required this.name,
    required this.phone,
    required this.address,
  });

  final String name;
  final String phone;
  final String address;

  UserProfile copyWith({
    String? name,
    String? phone,
    String? address,
  }) {
    return UserProfile(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
    );
  }
}
