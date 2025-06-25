import 'package:equatable/equatable.dart';

class AgreementEntity extends Equatable {
  final String id;
  final String title;
  final String dateRange;
  final double progress;
  final int totalStages;
  final int completedStages;
  final List<String> participantImageUrls;

  const AgreementEntity({
    required this.id,
    required this.title,
    required this.dateRange,
    required this.progress,
    required this.totalStages,
    required this.completedStages,
    required this.participantImageUrls,
  });

  @override
  List<Object?> get props => [id, title, dateRange, progress, totalStages, completedStages, participantImageUrls];
}
