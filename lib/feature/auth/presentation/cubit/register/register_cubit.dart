import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';
import 'package:moazez/feature/auth/domain/usecases/register_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/core/services/service_locator.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;
  final TeamCubit teamCubit;

  RegisterCubit({required this.registerUseCase, required this.teamCubit}) : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    emit(RegisterLoading());
    final result = await registerUseCase(
      RegisterParams(
        name: name,
        email: email,
        phone: phone,
        password: password,
      ),
    );
    result.fold(
      (failure) => emit(RegisterError(message: failure.message)),
      (authEntity) {
        emit(RegisterSuccess(authEntity: authEntity));
        sl<TeamCubit>().createTeam("فريقى");
      },
    );
  }
}
