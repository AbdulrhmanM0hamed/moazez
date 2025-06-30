import 'package:bloc/bloc.dart';
import 'package:moazez/feature/profile/domain/usecases/get_user_subscriptions_usecase.dart';
import 'user_subscriptions_state.dart';

class UserSubscriptionsCubit extends Cubit<UserSubscriptionsState> {
  final GetUserSubscriptionsUseCase getUserSubscriptionsUseCase;
  UserSubscriptionsCubit({required this.getUserSubscriptionsUseCase})
      : super(UserSubscriptionsInitial());

  Future<void> fetchUserSubscriptions() async {
    emit(UserSubscriptionsLoading());
    final result = await getUserSubscriptionsUseCase();
    result.fold(
      (failure) => emit(UserSubscriptionsError(message: failure.message)),
      (list) => emit(UserSubscriptionsLoaded(subscriptions: list)),
    );
  }
}
