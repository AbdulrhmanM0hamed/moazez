import 'package:dartz/dartz.dart' hide Task;
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/agreements/domain/entities/task.dart';
import 'package:moazez/feature/agreements/domain/repositories/agreements_repository.dart';

class CreateTaskUsecase extends UseCase<void, Task> {
  final AgreementsRepository repository;

  CreateTaskUsecase(this.repository);

  @override
  Future<Either<Failure, void>> call(Task params) async {
    return await repository.createTask(params);
  }
}
