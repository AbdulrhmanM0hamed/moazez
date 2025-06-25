import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/error/failures.dart';
import 'package:moazez/feature/packages/domain/usecases/get_packages_usecase.dart';
import 'package:moazez/feature/packages/presentation/cubit/package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  final GetPackagesUseCase getPackagesUseCase;

  PackageCubit({required this.getPackagesUseCase}) : super(PackageInitial());

  Future<void> getPackages() async {
    emit(PackageLoading());
    final result = await getPackagesUseCase();
    result.fold(
      (failure) {
        if (failure is ServerFailure) {
          emit(PackageError(message: failure.message));
        } else if (failure is NetworkFailure) {
          emit(PackageError(message: failure.message));
        } else {
          emit(PackageError(message: failure.message));
        }
      },
      (packages) {
        emit(PackageLoaded(packages: packages));
      },
    );
  }
}
