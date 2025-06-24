import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/network/network_info.dart';
import 'package:moazez/feature/send_invitations/data/datasources/invitation_remote_data_source.dart';
import 'package:moazez/feature/send_invitations/domain/entities/invitation_entity.dart';
import 'package:moazez/feature/send_invitations/domain/repositories/invitation_repository.dart';

class InvitationRepositoryImpl implements InvitationRepository {
  final InvitationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  InvitationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, InvitationEntity>> sendInvitation(String email) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInvitation = await remoteDataSource.sendInvitation(email);
        return Right( remoteInvitation);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالانترنت'));
    }
  }

  @override
  Future<Either<Failure, List<InvitationEntity>>> getSentInvitations() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteInvitations = await remoteDataSource.getSentInvitations();
        return Right(remoteInvitations);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message ?? 'خطأ في الخادم'));
      }
    } else {
      return Left(NetworkFailure(message: 'لا يوجد اتصال بالانترنت'));
    }
  }
}
