import 'package:equatable/equatable.dart';

class TeamMember extends Equatable {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;

  const TeamMember({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, avatarUrl];
}
