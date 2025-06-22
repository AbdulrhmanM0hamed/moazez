import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/domain/usecases/get_profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;

  ProfileCubit({required this.getProfileUseCase}) : super(ProfileInitial());

  Future<void> fetchProfile() async {
    if (isClosed) return;
    emit(ProfileLoading());
    final failureOrProfile = await getProfileUseCase();
    if (isClosed) return;
    failureOrProfile.fold(
      (failure) {
        if (!isClosed) emit(ProfileError(failure.message));
      },
      (userProfile) {
        if (!isClosed) emit(ProfileLoaded(userProfile));
      },
    );
  }
}
