import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int id;
  final String name;
  final String priceFormatted;
  final int maxTasks;
  final int? maxTeamMembers;
  final int? maxStagesPerTask;
  final int isTrial;

  const PackageEntity({
    required this.id,
    required this.name,
    required this.priceFormatted,
    required this.maxTasks,
    this.maxTeamMembers,
    this.maxStagesPerTask,
    required this.isTrial,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    priceFormatted,
    maxTasks,
    maxTeamMembers,
    maxStagesPerTask,
    isTrial,
  ];
}
