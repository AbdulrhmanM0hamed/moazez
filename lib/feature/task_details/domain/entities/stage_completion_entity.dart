class StageCompletionEntity {
  final int id;
  final String title;
  final String description;
  final String status;
  final int stageNumber;
  final String? proofNotes;
  final String? proofFiles;

  const StageCompletionEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.stageNumber,
    this.proofNotes,
    this.proofFiles,
  });
}
