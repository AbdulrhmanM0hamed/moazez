import 'package:dio/dio.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/packages/domain/models/package_entity.dart';

class PackagesRemoteDataSource {
  final Dio dio;

  PackagesRemoteDataSource(this.dio);

  Future<List<PackageEntity>> getPackages() async {
    final token = await sl<CacheService>().getToken();
    final response = await dio.get(
      ApiEndpoints.packages,
      options: Options(
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
    
    if (response.statusCode == 200 && (response.data['message'] as String).contains('تم جلب الباقات بنجاح')) {
      final List<dynamic> data = response.data['data'];
      return data.map((json) => PackageEntity.fromJson(json)).toList();
    }
    
    throw DioException(
      error: response.data['message'] ?? 'حدث خطأ غير متوقع',
      response: response,
      type: DioExceptionType.badResponse,
      requestOptions: RequestOptions(path: ApiEndpoints.packages),
    );
  }

  Future<PackageEntity> getTrialPackage() async {
    final token = await sl<CacheService>().getToken();
    final response = await dio.get(
      ApiEndpoints.trialPackage,
      options: Options(
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      ),
    );
    
    if (response.statusCode == 200 && (response.data['message'] as String).contains('الباقة التجريبية متاحة')) {
      final Map<String, dynamic> trialPackageData = response.data['trial_package'];
      return PackageEntity.fromJson(trialPackageData);
    }
    
    throw DioException(
      error: response.data['message'] ?? 'حدث خطأ غير متوقع',
      response: response,
      type: DioExceptionType.badResponse,
      requestOptions: RequestOptions(path: ApiEndpoints.trialPackage),
    );
  }
}
