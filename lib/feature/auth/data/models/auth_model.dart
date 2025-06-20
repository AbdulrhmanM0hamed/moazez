import 'package:moazez/feature/auth/data/models/user_model.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';

class AuthModel extends AuthEntity {
  const AuthModel({
    required UserModel user,
    required String token,
  }) : super(user: user, token: token);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }
}
