abstract class PasswordResetState {}

class PasswordResetInitial extends PasswordResetState {}

class PasswordResetLoading extends PasswordResetState {}

class PasswordResetSuccess extends PasswordResetState {
  final String message;

  PasswordResetSuccess(this.message);
}

class PasswordResetError extends PasswordResetState {
  final String message;

  PasswordResetError(this.message);
}
