import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/auth/domain/usecases/send_password_reset_link_usecase.dart';
import 'package:moazez/feature/auth/presentation/cubit/password_reset/password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  final SendPasswordResetLinkUseCase sendPasswordResetLinkUseCase;

  PasswordResetCubit({required this.sendPasswordResetLinkUseCase}) : super(PasswordResetInitial());

  Future<void> sendResetLink(String email) async {
    emit(PasswordResetLoading());
    final result = await sendPasswordResetLinkUseCase(email);
    result.fold(
      (failure) => emit(PasswordResetError(failure.message)),
      (message) => emit(PasswordResetSuccess(message)),
    );
  }
}
