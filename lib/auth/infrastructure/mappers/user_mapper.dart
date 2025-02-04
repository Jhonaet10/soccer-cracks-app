import 'package:app_project/auth/domain/entities/user.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json) => User(
      id: json['id'],
      email: json['email'],
      fullName: json['fullName'],
      avatar: json['avatar'],
      rol: json['rol'],
      token: json['token'],
      torneos: json['torneos']);
}
