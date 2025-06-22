import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
part 'complete_profile_state.dart';

class CompleteProfileCubit extends Cubit<CompleteProfileState> {
  final CompleteProfileUseCase useCase;
  CompleteProfileCubit(this.useCase) : super(CompleteProfileInitial());

  Future<void> submit(CompleteProfileParams params) async {
    emit(CompleteProfileLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(CompleteProfileError(failure.message)),
      (user) => emit(CompleteProfileSuccess(user)),
    );
  }
}
