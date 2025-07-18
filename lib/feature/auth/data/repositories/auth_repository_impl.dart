import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/auth/data/datasources/auth_remote_data_source.dart';

import 'package:moazez/feature/auth/data/models/auth_model.dart';
import 'package:moazez/feature/auth/domain/repositories/auth_repository.dart';
import 'package:moazez/feature/auth/domain/usecases/complete_profile_usecase.dart';
import 'package:moazez/feature/auth/domain/usecases/register_usecase.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
 

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthModel>> login(String email, String password) async {
    try {
      final result = await remoteDataSource.login(email, password);
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, AuthModel>> register(RegisterParams params) async {
    try {
      final result = await remoteDataSource.register(
        name: params.name,
        email: params.email,
        phone: params.phone,
        password: params.password,
      );
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> completeProfile(CompleteProfileParams params) async {
    try {
      final result = await remoteDataSource.completeProfile(params);
      return Right(result);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, void>> subscribeToTrialPackage(String token) async {
    try {
      await remoteDataSource.subscribeToTrialPackage(token);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }

  @override
  Future<Either<Failure, String>> sendPasswordResetLink(String email) async {
    try {
      final message = await remoteDataSource.sendPasswordResetLink(email);
      return Right(message);
    } on Failure catch (f) {
      return Left(f);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'حدث خطأ غير معروف'));
    }
  }
}
