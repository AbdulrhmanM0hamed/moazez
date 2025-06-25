import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/home_supporter/data/datasources/team_remote_data_source.dart';
import 'package:moazez/feature/home_supporter/domain/entities/team_entity.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/team_repository.dart';

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
        debugPrint('Fetching team info from remote data source...');
        final remoteTeam = await remoteDataSource.getTeamInfo();
        debugPrint('Team info fetched successfully: ${remoteTeam.name}');
        return Right(remoteTeam);
      } on ServerException catch (e) {
        debugPrint('ServerException while fetching team info: ${e.message}');
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      debugPrint('No internet connection while fetching team info');
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> createTeam(String teamName) async {
    if (await networkInfo.isConnected) {
      try {
        debugPrint('Creating team with name: $teamName');
        final remoteTeam = await remoteDataSource.createTeam(teamName);
        debugPrint('Team created successfully: ${remoteTeam.name}');
        return Right(remoteTeam);
      } on ServerException catch (e) {
        debugPrint('ServerException while creating team: ${e.message}');
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      debugPrint('No internet connection while creating team');
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> updateTeamName(String newName) async {
    if (await networkInfo.isConnected) {
      try {
        debugPrint('Updating team name to: $newName');
        final remoteTeam = await remoteDataSource.updateTeamName(newName);
        debugPrint('Team name updated successfully: ${remoteTeam.name}');
        return Right(remoteTeam);
      } on ServerException catch (e) {
        debugPrint('ServerException while updating team name: ${e.message}');
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      debugPrint('No internet connection while updating team name');
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }

  @override
  Future<Either<Failure, TeamEntity>> removeTeamMember(int memberId) async {
    if (await networkInfo.isConnected) {
      try {
        debugPrint('Removing team member with ID: $memberId');
        final remoteTeam = await remoteDataSource.removeTeamMember(memberId);
        debugPrint('Team member removed successfully');
        return Right(remoteTeam);
      } on ServerException catch (e) {
        debugPrint('ServerException while removing team member: ${e.message}');
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      debugPrint('No internet connection while removing team member');
      return const Left(NetworkFailure(message: 'لا يوجد اتصال بالإنترنت'));
    }
  }
}
