import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/search/domain/entities/search_result_entity.dart';
import 'package:moazez/feature/search/domain/repositories/search_repository.dart';

class SearchUseCase extends UseCase<SearchResultEntity, SearchParams> {
  final SearchRepository repository;

  SearchUseCase({required this.repository});

  @override
  Future<Either<Failure, SearchResultEntity>> call(SearchParams params) async {
    return await repository.search(query: params.query, type: params.type);
  }
}

class SearchParams extends Equatable {
  final String query;
  final String type;

  const SearchParams({required this.query, required this.type});

  @override
  List<Object?> get props => [query, type];
}
