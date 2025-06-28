import 'package:equatable/equatable.dart';
import 'package:moazez/feature/search/domain/entities/search_member_entity.dart';
import 'package:moazez/feature/search/domain/entities/search_task_entity.dart';

class SearchResultEntity extends Equatable {
  final List<SearchTaskEntity> tasks;
  final List<SearchMemberEntity> members;
  final int totalResults;

  const SearchResultEntity({
    required this.tasks,
    required this.members,
    required this.totalResults,
  });

  @override
  List<Object?> get props => [tasks, members, totalResults];
}
