class AdminUser {
  final String id;
  final String username;
  final String email;
  final String role;
  final bool isDisabled;

  AdminUser({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    required this.isDisabled,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['_id'] ?? json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      isDisabled: json['isDisabled'] ?? false,
    );
  }
}
