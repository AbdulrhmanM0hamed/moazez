import 'package:equatable/equatable.dart';

class SearchMemberEntity extends Equatable {
  final int id;
  final String name;
  final String? avatarUrl;

  const SearchMemberEntity({
    required this.id,
    required this.name,
    this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
