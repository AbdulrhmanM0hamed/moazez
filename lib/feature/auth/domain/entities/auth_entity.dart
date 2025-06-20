import 'package:equatable/equatable.dart';
import 'user_entity.dart';

class AuthEntity extends Equatable {
  final UserEntity user;
  final String token;

  const AuthEntity({required this.user, required this.token});

  @override
  List<Object?> get props => [user, token];
}
