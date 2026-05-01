class User {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.role,
  });
}
