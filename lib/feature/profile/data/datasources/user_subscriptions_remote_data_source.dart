import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import '../models/user_subscription_model.dart';

abstract class UserSubscriptionsRemoteDataSource {
  Future<List<UserSubscriptionModel>> getUserSubscriptions();
}

class UserSubscriptionsRemoteDataSourceImpl
    implements UserSubscriptionsRemoteDataSource {
  final Dio dio;
  UserSubscriptionsRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserSubscriptionModel>> getUserSubscriptions() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.subscriptions}',
        options: Options(headers: {
          'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
        }),
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final List listJson = response.data['data'] as List;
        return listJson
            .map((e) => UserSubscriptionModel.fromJson(e))
            .toList();
      }
      throw ServerException(
          message:
              'فشل في جلب الاشتراكات: حالة الاستجابة ${response.statusCode}');
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: 'خطأ غير متوقع: ${e.toString()}');
    }
  }
}
