import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:moazez/feature/auth/domain/entities/auth_entity.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final CacheService cacheService;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.cacheService,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteAuth = await remoteDataSource.login(email, password);
        // Save token and user data upon successful login
        await cacheService.saveToken(remoteAuth.token);
        await cacheService.saveUser({
          'id': remoteAuth.user.id,
          'name': remoteAuth.user.name,
          'email': remoteAuth.user.email,
        });
        return Right(remoteAuth);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
      }
    } else {
      return Left(const NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
