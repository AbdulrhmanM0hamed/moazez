import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/home/data/models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<SubscriptionModel> getCurrentSubscription();
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final Dio dio;

  SubscriptionRemoteDataSourceImpl({required this.dio});

  @override
  Future<SubscriptionModel> getCurrentSubscription() async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.currentSubscription}',
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null) {
          return SubscriptionModel.fromJson(data);
        } else {
          throw ServerException(message: 'البيانات المسترجعة غير صحيحة أو فارغة');
        }
      } else {
        throw ServerException(message: 'فشل في جلب الاشتراك الحالي');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
