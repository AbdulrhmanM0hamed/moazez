import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/packages/data/models/package_model.dart';

abstract class PackageRemoteDataSource {
  Future<List<PackageModel>> getPackages();
}

class PackageRemoteDataSourceImpl implements PackageRemoteDataSource {
  final Dio dio;

  PackageRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PackageModel>> getPackages() async {
    try {
      // ignore: avoid_print
      print("🔵 [PackageRemoteDataSource] Fetching packages from: ${ApiEndpoints.baseUrl + ApiEndpoints.packages}");
      final response = await dio.get(ApiEndpoints.baseUrl + ApiEndpoints.packages);
      // ignore: avoid_print
      print("🔵 [PackageRemoteDataSource] Status Code: ${response.statusCode}");
      // ignore: avoid_print
      print("🔵 [PackageRemoteDataSource] Full Response: ${response.data}");
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        // ignore: avoid_print
        print("🟢 [PackageRemoteDataSource] Packages count: ${data.length}");
        return data.map((json) => PackageModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل في تحميل البيانات');
      }
    } on DioException catch (e) {
      // ignore: avoid_print
      print("🔴 [PackageRemoteDataSource] DioException: ${e.message}");
      throw handleDioException(e);
    } catch (e) {
      // ignore: avoid_print
      print("🔴 [PackageRemoteDataSource] Unknown error: $e");
      throw ServerException(message: 'فشل في تحميل البيانات');
    }
  }
}
