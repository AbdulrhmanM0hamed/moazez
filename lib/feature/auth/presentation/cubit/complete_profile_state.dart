part of 'complete_profile_cubit.dart';

abstract class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {
  final UserProfile user;
  CompleteProfileSuccess(this.user);
}

class CompleteProfileError extends CompleteProfileState {
  final String message;
  CompleteProfileError(this.message);
}
