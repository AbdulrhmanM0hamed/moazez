import 'package:moazez/feature/search/domain/entities/search_task_entity.dart';

class SearchTaskModel extends SearchTaskEntity {
  const SearchTaskModel({
    required super.id,
    required super.title,
    required super.status,
    required super.progress,
    super.dueDate,
    required super.createdAt,
    required CreatorModel super.creator,
  });

  factory SearchTaskModel.fromJson(Map<String, dynamic> json) {
    return SearchTaskModel(
      id: json['id'],
      title: json['title'],
      status: json['status'],
      progress: json['progress'],
      dueDate: json['due_date'],
      createdAt: json['created_at'],
      creator: CreatorModel.fromJson(json['creator']),
    );
  }
}

class CreatorModel extends CreatorEntity {
  const CreatorModel({
    required super.id,
    required super.name,
    required super.avatarUrl,
  });

  factory CreatorModel.fromJson(Map<String, dynamic> json) {
    return CreatorModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
