import 'package:equatable/equatable.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final AuthEntity authEntity;

  const LoginSuccess({required this.authEntity});

  @override
  List<Object> get props => [authEntity];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object> get props => [message];
}
