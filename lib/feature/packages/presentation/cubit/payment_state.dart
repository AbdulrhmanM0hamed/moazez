abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class PaymentSuccess extends PaymentState {
  final String paymentUrl;

  PaymentSuccess({required this.paymentUrl});
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError({required this.message});
}
