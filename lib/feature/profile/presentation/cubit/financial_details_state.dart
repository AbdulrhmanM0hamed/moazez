import 'package:equatable/equatable.dart';
import 'package:moazez/feature/profile/domain/entities/financial_details_entity.dart';

abstract class FinancialDetailsState extends Equatable {
  const FinancialDetailsState();

  @override
  List<Object> get props => [];
}

class FinancialDetailsInitial extends FinancialDetailsState {}

class FinancialDetailsLoading extends FinancialDetailsState {}

class FinancialDetailsLoaded extends FinancialDetailsState {
  final FinancialDetailsEntity financialDetails;

  const FinancialDetailsLoaded({required this.financialDetails});

  @override
  List<Object> get props => [financialDetails];
}

class FinancialDetailsError extends FinancialDetailsState {
  final String message;

  const FinancialDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}
