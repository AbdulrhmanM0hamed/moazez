import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/logout_usecase.dart';

part 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase logoutUseCase;
  final CacheService cacheHelper;

  LogoutCubit({
    required this.logoutUseCase,
    required this.cacheHelper,
  }) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(LogoutFailure(message: failure.message)),
      (_) async {
        await cacheHelper.clearCache();
        emit(LogoutSuccess());
      },
    );
  }
}
