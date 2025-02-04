class User {
  final String id;
  final String email;
  final String fullName;
  final String? avatar;
  final String? rol;
  final String token;
  final List<String>? torneos;

  User(
      {required this.id,
      required this.email,
      required this.fullName,
      required this.rol,
      required this.avatar,
      required this.torneos,
      required this.token});

  bool get isAdmin {
    return rol == 'admin';
  }
}
