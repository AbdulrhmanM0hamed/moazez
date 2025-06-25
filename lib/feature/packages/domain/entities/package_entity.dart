import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int id;
  final String name;
  final String? description;
  final String price;
  final String priceFormatted;
  final int? durationDays;
  final String durationText;
  final int maxTasks;
  final String maxTasksText;
  final int? maxTeamMembers;
  final String maxTeamMembersText;
  final List<dynamic> features;
  final int isTrial;
  final bool isPopular;
  final String? badge;

  const PackageEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.priceFormatted,
    this.durationDays,
    required this.durationText,
    required this.maxTasks,
    required this.maxTasksText,
    this.maxTeamMembers,
    required this.maxTeamMembersText,
    required this.features,
    required this.isTrial,
    required this.isPopular,
    this.badge,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        priceFormatted,
        durationDays,
        durationText,
        maxTasks,
        maxTasksText,
        maxTeamMembers,
        maxTeamMembersText,
        features,
        isTrial,
        isPopular,
        badge,
      ];
}
