import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String userType;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.userType,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, email, userType, isActive];
}
