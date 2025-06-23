import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';
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

      PackageEntity? trialPackage;
      trialPackageResult.fold(
        (failure) {
          // If trial package fetch fails, continue without it
        },
        (package) {
          trialPackage = package;
        },
      );

      final packages = packagesResult.fold(
        (failure) {
          emit(PackagesError("فشل في جلب الباقات: ${failure.message}"));
          return <PackageEntity>[];
        },
        (packages) => packages,
      );

      if (packages.isNotEmpty || trialPackage != null) {
        emit(PackagesLoaded(
          trialPackage: trialPackage,
          packages: packages,
        ));
      } else if (packages.isEmpty && trialPackage == null) {
        emit(PackagesError("لا توجد باقات متاحة حاليًا."));
      }
    } catch (e) {
      emit(PackagesError("خطأ غير متوقع: ${e.toString()}"));
    }
  }
}
