import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/search/data/datasources/search_remote_data_source.dart';
import 'package:moazez/feature/search/domain/entities/search_result_entity.dart';
import 'package:moazez/feature/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SearchResultEntity>> search({
    required String query,
    required String type,
  }) async {
    try {
      final result = await remoteDataSource.search(query: query, type: type);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ في الخادم، يرجى المحاولة مرة أخرى.'));
    } catch (e) {
        return Left(ServerFailure(message: e.toString()));
    }
  }
}
