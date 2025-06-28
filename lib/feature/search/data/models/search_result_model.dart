import 'package:moazez/feature/search/data/models/search_member_model.dart';
import 'package:moazez/feature/search/data/models/search_task_model.dart';
import 'package:moazez/feature/search/domain/entities/search_result_entity.dart';

class SearchResultModel extends SearchResultEntity {
  const SearchResultModel({
    required List<SearchTaskModel> tasks,
    required List<SearchMemberModel> members,
    required int totalResults,
  }) : super(tasks: tasks, members: members, totalResults: totalResults);

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      tasks: (json['tasks'] as List? ?? []).map((e) => SearchTaskModel.fromJson(e)).toList(),
      members: (json['members'] as List? ?? []).map((e) => SearchMemberModel.fromJson(e)).toList(),
      totalResults: json['total_results'] ?? 0,
    );
  }
}
