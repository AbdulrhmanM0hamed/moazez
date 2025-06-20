import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/auth/domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit({required this.loginUseCase}) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());
    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );
    result.fold(
      (failure) => emit(LoginError(message: failure.message)),
      (authEntity) => emit(LoginSuccess(authEntity: authEntity)),
    );
  }
}
