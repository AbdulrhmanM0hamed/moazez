import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/profile/domain/usecases/get_financial_details_usecase.dart';
import 'package:moazez/feature/profile/presentation/cubit/financial_details_state.dart';

class FinancialDetailsCubit extends Cubit<FinancialDetailsState> {
  final GetFinancialDetailsUseCase getFinancialDetailsUseCase;

  FinancialDetailsCubit({required this.getFinancialDetailsUseCase})
      : super(FinancialDetailsInitial());

  Future<void> fetchFinancialDetails() async {
    emit(FinancialDetailsLoading());
    final failureOrDetails = await getFinancialDetailsUseCase(NoParams());
    failureOrDetails.fold(
      (failure) => emit(FinancialDetailsError(message: failure.message)),
      (details) => emit(FinancialDetailsLoaded(financialDetails: details)),
    );
  }
}
