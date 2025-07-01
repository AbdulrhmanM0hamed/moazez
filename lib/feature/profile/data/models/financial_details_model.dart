import 'package:moazez/feature/profile/domain/entities/financial_details_entity.dart';

class FinancialDetailsModel extends FinancialDetailsEntity {
  const FinancialDetailsModel({
    required super.whatsappNumber,
    required super.phoneNumber,
    required super.email,
    required super.bankAccountDetails,
  });

  factory FinancialDetailsModel.fromJson(Map<String, dynamic> json) {
    return FinancialDetailsModel(
      whatsappNumber: json['whatsapp_number'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'] ?? '',
      bankAccountDetails: json['bank_account_details'] ?? '',
    );
  }
}
