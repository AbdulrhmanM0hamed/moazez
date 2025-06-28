import 'package:moazez/feature/search/domain/entities/search_member_entity.dart';

class SearchMemberModel extends SearchMemberEntity {
  const SearchMemberModel({
    required super.id,
    required super.name,
    super.avatarUrl,
  });

  factory SearchMemberModel.fromJson(Map<String, dynamic> json) {
    // Assuming the member object in the response might not have an avatar.
    // The API response for members in the example doesn't show an avatar_url,
    // so we'll handle it gracefully.
    return SearchMemberModel(
      id: json['id'],
      name: json['name'],
      avatarUrl: json['avatar_url'], // This might be null
    );
  }
}
