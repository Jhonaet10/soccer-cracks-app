import 'package:app_project/auth/domain/entities/user.dart';
import 'package:app_project/auth/domain/entities/role.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) {
    String? rolText;
    UserRole? role;

    if (json['rol'] != null) {
      switch (json['rol'].toString()) {
        case 'Jugador':
          role = UserRole.player;
          rolText = 'Jugador';
          break;
        case 'Árbitro':
          role = UserRole.referee;
          rolText = 'Árbitro';
          break;
        case 'Organizador':
          role = UserRole.organizer;
          rolText = 'Organizador';
          break;
        case 'new_user':
          role = null;
          rolText = null;
          break;
        default:
          role = null;
          rolText = null;
      }
    }

    print('Rol mapeado: $rolText');
    print('Torneos recibidos: ${json['torneos']}');

    // Asegurar que los torneos se mapeen correctamente
    List<String>? torneos;
    if (json['torneos'] != null) {
      if (json['torneos'] is List) {
        torneos = List<String>.from(json['torneos']);
      } else if (json['torneos'] is Map) {
        // Si viene como un mapa de Firestore, extraer los valores
        torneos =
            (json['torneos'] as Map).values.map((e) => e.toString()).toList();
      }
    }

    print('Torneos mapeados: $torneos');

    return User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      rol: role,
      token: json['token'],
      torneos: torneos,
    );
  }

  static Map<String, dynamic> userEntityToJson(User user) {
    String? rolName;
    switch (user.rol) {
      case UserRole.player:
        rolName = 'Jugador';
        break;
      case UserRole.referee:
        rolName = 'Árbitro';
        break;
      case UserRole.organizer:
        rolName = 'Organizador';
        break;
      default:
        rolName = null;
    }

    final json = {
      'id': user.id,
      'email': user.email,
      'fullName': user.fullName,
      'avatar': user.avatar,
      'rol': rolName,
      'torneos': user.torneos,
      'token': user.token,
    };
    print('Usuario convertido a JSON: $json');
    return json;
  }
}
