import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.packageType,
    required super.createdAt,
    super.paymentUrl,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as int,
      orderId: json['order_id'] as int,
      amount: json['amount'] as String,
      currency: json['currency'] as String,
      status: json['status'] as String,
      packageType: json['package_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      paymentUrl: json['payment_url'] as String?,
    );
  }
}
