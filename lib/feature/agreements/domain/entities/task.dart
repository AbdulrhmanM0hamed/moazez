import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String startDate;
  final int durationDays;
  final String endDate;
  final String status;
  final String priority;
  final String rewardType;
  final double? rewardAmount;
  final String? rewardDescription;
  final int isMultiple;
  final List<int> selectedMembers;
  final int receiverId;
  final int totalStages;

  const Task({
    this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.durationDays,
    required this.endDate,
    required this.status,
    required this.priority,
    required this.rewardType,
    this.rewardAmount,
    this.rewardDescription,
    required this.isMultiple,
    required this.selectedMembers,
    required this.receiverId,
    required this.totalStages,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startDate,
        durationDays,
        endDate,
        status,
        priority,
        rewardType,
        rewardAmount,
        rewardDescription,
        isMultiple,
        selectedMembers,
        receiverId,
        totalStages,
      ];
}
