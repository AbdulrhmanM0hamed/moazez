import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/home/data/datasources/team_remote_data_source.dart';
import 'package:moazez/feature/home/domain/entities/team_entity.dart';
import 'package:moazez/feature/home/domain/repositories/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TeamRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, TeamEntity>> getTeamInfo() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTeam = await remoteDataSource.getTeamInfo();
        return Right(remoteTeam);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> createTeam(String teamName) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTeam = await remoteDataSource.createTeam(teamName);
        return Right(remoteTeam);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
