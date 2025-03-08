import 'role.dart';

class User {
  final String id;
  final String email;
  final String fullName;
  final String? avatar;
  final UserRole? rol;
  final String token;
  final List<String>? torneos;

  User({
    required this.id,
    required this.email,
    required this.fullName,
    required this.rol,
    required this.avatar,
    required this.torneos,
    required this.token,
  });

  bool get isAdmin {
    return rol == UserRole.organizer;
  }

  bool get hasTournaments {
    return torneos != null && torneos!.isNotEmpty;
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, fullName: $fullName, avatar: $avatar, rol: $rol, torneos: $torneos, token: $token)';
  }

  bool hasPermission(String permission) {
    if (rol == null) return false;
    return rol!.permissions.contains(permission);
  }
}
