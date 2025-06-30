import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_payments_usecase.dart';
import '../../domain/entities/payment_entity.dart';
part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  final GetPaymentsUseCase getPaymentsUseCase;
  PaymentsCubit({required this.getPaymentsUseCase}) : super(PaymentsInitial());

  Future<void> fetchPayments() async {
    emit(PaymentsLoading());
    final result = await getPaymentsUseCase();
    result.fold(
      (failure) => emit(PaymentsError(failure.message)),
      (payments) => emit(PaymentsLoaded(payments)),
    );
  }
}
