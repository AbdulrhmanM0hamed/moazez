import 'package:equatable/equatable.dart';
import '../../domain/entities/user_subscription_entity.dart';

abstract class UserSubscriptionsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserSubscriptionsInitial extends UserSubscriptionsState {}

class UserSubscriptionsLoading extends UserSubscriptionsState {}

class UserSubscriptionsLoaded extends UserSubscriptionsState {
  final List<UserSubscriptionEntity> subscriptions;
  UserSubscriptionsLoaded({required this.subscriptions});

  @override
  List<Object?> get props => [subscriptions];
}

class UserSubscriptionsError extends UserSubscriptionsState {
  final String message;
  UserSubscriptionsError({required this.message});
  @override
  List<Object?> get props => [message];
}
