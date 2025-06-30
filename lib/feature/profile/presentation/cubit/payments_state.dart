part of 'payments_cubit.dart';


abstract class PaymentsState {}

class PaymentsInitial extends PaymentsState {}

class PaymentsLoading extends PaymentsState {}

class PaymentsLoaded extends PaymentsState {
  final List<PaymentEntity> payments;
  PaymentsLoaded(this.payments);
}

class PaymentsError extends PaymentsState {
  final String message;
  PaymentsError(this.message);
}
