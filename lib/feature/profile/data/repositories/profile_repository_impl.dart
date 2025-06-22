import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/profile/data/datasources/profile_remote_data_source.dart';
import 'package:moazez/feature/profile/data/models/profile_model.dart';
import 'package:moazez/feature/profile/domain/repositories/profile_repository.dart';
import 'package:moazez/feature/profile/data/models/edit_profile_params.dart';
import 'dart:developer' as dev;

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProfileResponse>> getProfile() async {
    try {
      dev.log('Calling remoteDataSource.getProfile()', name: 'ProfileRepository');
      final response = await remoteDataSource.getProfile();
      dev.log('Profile fetched successfully', name: 'ProfileRepository');
      return Right(response);
    } on Failure catch (f) {
      dev.log('Failure from data source: ${f.message}', name: 'ProfileRepository');
      return Left(f);
    } catch (e) {
      dev.log('Unexpected error: $e', error: e, name: 'ProfileRepository');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<Either<Failure, ProfileResponse>> editProfile(EditProfileParams params) async {
    try {
      dev.log('Calling remoteDataSource.editProfile()', name: 'ProfileRepository');
      final profileResponse = await remoteDataSource.editProfile(params);
      dev.log('Profile updated successfully', name: 'ProfileRepository');
      return Right(profileResponse);
    } on Failure catch (f) {
      dev.log('Failure from data source: ${f.message}', name: 'ProfileRepository');
      return Left(f);
    } catch (e) {
      dev.log('Unexpected error: $e', error: e, name: 'ProfileRepository');
      return Left(ServerFailure(message: 'حدث خطأ غير متوقع'));
    }
  }
}
