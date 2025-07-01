import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/profile/data/models/financial_details_model.dart';

abstract class FinancialDetailsRemoteDataSource {
  Future<FinancialDetailsModel> getFinancialDetails();
}

class FinancialDetailsRemoteDataSourceImpl
    implements FinancialDetailsRemoteDataSource {
  final Dio dio;

  FinancialDetailsRemoteDataSourceImpl({required this.dio});

  @override
  Future<FinancialDetailsModel> getFinancialDetails() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.financialDetails}',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        return FinancialDetailsModel.fromJson(response.data['data']);
      }
      throw ServerException(
        message: 'Failed to fetch financial details: ${response.statusCode}',
      );
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Server Error');
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: $e');
    }
  }
}
