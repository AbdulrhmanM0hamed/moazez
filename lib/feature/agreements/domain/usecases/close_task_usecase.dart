import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';

class CloseTaskUseCase {
  final AgreementsRepository repository;

  CloseTaskUseCase(this.repository);

  Future<Either<Failure, String>> call(CloseTaskParams params) async {
    return await repository.closeTask(
      taskId: params.taskId,
      status: params.status,
    );
  }
}

class CloseTaskParams extends Equatable {
  final String taskId;
  final String status;

  const CloseTaskParams({required this.taskId, required this.status});

  @override
  List<Object?> get props => [taskId, status];
}
