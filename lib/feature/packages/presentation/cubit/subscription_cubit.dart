import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/packages/domain/usecases/get_current_subscription_usecase.dart';
import 'package:moazez/feature/packages/presentation/cubit/subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  final GetCurrentSubscriptionUseCase getCurrentSubscriptionUseCase;

  SubscriptionCubit({required this.getCurrentSubscriptionUseCase}) : super(SubscriptionInitial());

  Future<void> fetchCurrentSubscription() async {
    emit(SubscriptionLoading());
    final result = await getCurrentSubscriptionUseCase(NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(message: failure.message ?? 'خطأ غير معروف أثناء جلب بيانات الاشتراك')),
      (subscription) {
        if(!isClosed){
          emit(SubscriptionLoaded(subscription: subscription));
        }
      },
    );
  }
}
