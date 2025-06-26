import 'package:dartz/dartz.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/home_supporter/domain/entities/member_stats_entity.dart';
import 'package:moazez/feature/home_supporter/domain/repositories/team_repository.dart';

class GetMemberTaskStatsUseCase {
  final TeamRepository teamRepository;

  GetMemberTaskStatsUseCase({required this.teamRepository});

  Future<Either<Exception, MemberTaskStatsResponseEntity>> call(int page) async {
    return await teamRepository.getMemberTaskStats(page);
  }
}
