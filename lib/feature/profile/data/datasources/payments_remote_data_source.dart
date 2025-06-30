import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import '../models/payment_model.dart';

abstract class PaymentsRemoteDataSource {
  Future<List<PaymentModel>> fetchPayments();
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  final Dio dio;
  PaymentsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<PaymentModel>> fetchPayments() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.payments}',
        options: Options(headers: {
          'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
        }),
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final List list = response.data['data'] as List;
      return list.map((e) => PaymentModel.fromJson(e)).toList();
      }
      throw ServerException(message: 'فشل جلب المدفوعات: حالة الاستجابة ${response.statusCode}');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
