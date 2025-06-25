import 'package:equatable/equatable.dart';
import 'package:moazez/feature/rewards/domain/entities/reward_entity.dart';

abstract class RewardState extends Equatable {
  const RewardState();

  @override
  List<Object> get props => [];
}

class RewardInitial extends RewardState {}

class RewardLoading extends RewardState {}

class RewardLoaded extends RewardState {
  final List<RewardEntity> rewards;

  const RewardLoaded({required this.rewards});

  @override
  List<Object> get props => [rewards];
}

class RewardError extends RewardState {
  final String message;

  const RewardError({required this.message});

  @override
  List<Object> get props => [message];
}
