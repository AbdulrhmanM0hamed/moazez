import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';

class StageCompletionModel extends StageCompletionEntity {
  const StageCompletionModel({
    required int id,
    String? proofNotes,
    String? proofImage,
  }) : super(
          id: id,
          proofNotes: proofNotes,
          proofImage: proofImage,
        );

  factory StageCompletionModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    return StageCompletionModel(
      id: data['id'] ?? 0,
      proofNotes: data['proof_notes'] ?? '',
      proofImage: data['proof_image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'proof_notes': proofNotes,
      'proof_image': proofImage ?? '',
    };
  }
}
