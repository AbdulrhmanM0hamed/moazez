import 'package:equatable/equatable.dart';

class FinancialDetailsEntity extends Equatable {
  final String whatsappNumber;
  final String phoneNumber;
  final String email;
  final String bankAccountDetails;

  const FinancialDetailsEntity({
    required this.whatsappNumber,
    required this.phoneNumber,
    required this.email,
    required this.bankAccountDetails,
  });

  @override
  List<Object?> get props => [
        whatsappNumber,
        phoneNumber,
        email,
        bankAccountDetails,
      ];
}
