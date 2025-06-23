import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/packages/domain/repositories/packages_repository.dart';
import 'package:moazez/feature/packages/presentation/cubit/packages_state.dart';

class PackagesCubit extends Cubit<PackagesState> {
  final PackagesRepository repository;

  PackagesCubit(this.repository) : super(PackagesLoading());

  Future<void> fetchPackages() async {
    emit(PackagesLoading());

    try {
      final trialPackageResult = await repository.getTrialPackage();
      final packagesResult = await repository.getPackages();

      final trialPackage = trialPackageResult.fold(
        (failure) => throw failure,
        (package) => package,
      );

      final packages = packagesResult.fold(
        (failure) => throw failure,
        (packages) => packages,
      );

      emit(PackagesLoaded(
        trialPackage: trialPackage,
        packages: packages,
      ));
    } catch (e) {
      emit(PackagesError(e.toString()));
    }
  }
}
