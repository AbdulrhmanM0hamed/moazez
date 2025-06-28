import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/search/domain/usecases/search_usecase.dart';
import 'package:moazez/feature/search/presentation/cubit/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchUseCase searchUseCase;

  SearchCubit({required this.searchUseCase}) : super(SearchInitial());

  Future<void> performSearch(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    // As per user request, the type is always 'task'
    final result = await searchUseCase(SearchParams(query: query, type: 'task'));
    result.fold(
      (failure) {
        emit(SearchError(message: _mapFailureToMessage(failure)));
      },
      (searchResult) => emit(SearchLoaded(searchResult: searchResult)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى.';
      case UnauthorizedFailure:
        return 'ليس لديك الصلاحية للوصول. يرجى تسجيل الدخول مرة أخرى.';
      case NetworkFailure:
        return 'أنت غير متصل بالإنترنت. يرجى التحقق من اتصالك.';
      default:
        return 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى.';
    }
  }

  void resetSearch() {
    emit(SearchInitial());
  }
}
