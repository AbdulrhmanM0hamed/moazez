import 'package:moazez/feature/packages/domain/entities/package_entity.dart';

class DummyPackageData {
  static List<PackageEntity> getDummyPackages() {
    return [
      PackageEntity(
        id: 1,
        name: 'الباقة المجانية',
        priceFormatted: 'مجاني',
        maxTasks: 5,
        maxTeamMembers: 3,
        maxStagesPerTask: 3,
        isTrial: true,
      ),
      PackageEntity(
        id: 2,
        name: 'الباقة الأساسية',
        priceFormatted: '99 ريال',
        maxTasks: 15,
        maxTeamMembers: 10,
        maxStagesPerTask: 5,
        isTrial: false,
      ),
      PackageEntity(
        id: 3,
        name: 'الباقة المتقدمة',
        priceFormatted: '199 ريال',
        maxTasks: 50,
        maxTeamMembers: 25,
        maxStagesPerTask: 10,
        isTrial: false,
      ),
    ];
  }
}
