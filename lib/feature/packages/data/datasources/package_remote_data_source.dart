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
      final response = await dio.get(ApiEndpoints.baseUrl + ApiEndpoints.packages);
      if (response.statusCode == 200) {
        final data = response.data['data'] as List<dynamic>;
        return data.map((json) => PackageModel.fromJson(json)).toList();
      } else {
        throw ServerException(message: 'فشل في تحميل البيانات');
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'فشل في تحميل البيانات');
    }
  }
}
