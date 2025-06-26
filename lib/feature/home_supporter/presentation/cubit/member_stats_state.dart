import 'package:moazez/feature/home_supporter/data/models/member_stats_model.dart';

abstract class MemberStatsState {}

class MemberStatsInitial extends MemberStatsState {}

class MemberStatsLoading extends MemberStatsState {}

class MemberStatsLoaded extends MemberStatsState {
  final MemberTaskStatsResponseModel response;

  MemberStatsLoaded({required this.response});
}

class MemberStatsError extends MemberStatsState {
  final String message;

  MemberStatsError({required this.message});
}
