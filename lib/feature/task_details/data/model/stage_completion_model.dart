import 'package:moazez/feature/task_details/domain/entities/stage_completion_entity.dart';

class StageCompletionModel extends StageCompletionEntity {
  const StageCompletionModel({
    required int id,
    required String title,
    required String description,
    required String status,
    required int stageNumber,
    String? proofNotes,
    String? proofFiles,
  }) : super(
          id: id,
          title: title,
          description: description,
          status: status,
          stageNumber: stageNumber,
          proofNotes: proofNotes,
          proofFiles: proofFiles,
        );

  factory StageCompletionModel.fromJson(Map<String, dynamic> json) {
    return StageCompletionModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      status: json['status'],
      stageNumber: json['stage_number'],
      proofNotes: json['proof_notes'],
      proofFiles: json['proof_files'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'stage_number': stageNumber,
      'proof_notes': proofNotes,
      'proof_files': proofFiles,
    };
  }
}
