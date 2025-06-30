import 'package:equatable/equatable.dart';

class PaymentEntity extends Equatable {
  final int id;
  final int orderId;
  final String amount;
  final String currency;
  final String status;
  final String packageType;
  final DateTime createdAt;
  final String? paymentUrl;

  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.packageType,
    required this.createdAt,
    this.paymentUrl,
  });

  @override
  List<Object?> get props => [id, orderId, amount, currency, status, packageType, createdAt, paymentUrl];
}
