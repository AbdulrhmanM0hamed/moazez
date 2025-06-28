import 'package:equatable/equatable.dart';
import 'package:moazez/feature/search/domain/entities/search_result_entity.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final SearchResultEntity searchResult;

  const SearchLoaded({required this.searchResult});

  @override
  List<Object> get props => [searchResult];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
}
