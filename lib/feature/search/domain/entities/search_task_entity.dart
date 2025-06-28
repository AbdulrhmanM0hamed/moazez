import 'package:equatable/equatable.dart';

class SearchTaskEntity extends Equatable {
  final int id;
  final String title;
  final String status;
  final int progress;
  final String? dueDate;
  final String createdAt;
  final CreatorEntity creator;

  const SearchTaskEntity({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    this.dueDate,
    required this.createdAt,
    required this.creator,
  });

  @override
  List<Object?> get props => [id, title, status, progress, dueDate, createdAt, creator];
}

class CreatorEntity extends Equatable {
  final int id;
  final String name;
  final String avatarUrl;

  const CreatorEntity({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, avatarUrl];
}
