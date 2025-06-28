import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/search/domain/entities/search_result_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, SearchResultEntity>> search({
    required String query,
    required String type,
  });
}
