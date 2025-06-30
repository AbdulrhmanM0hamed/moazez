import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/packages/data/models/subscription_model.dart';

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
        options: Options(
          headers: {
            'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
          },
        ),
      );
      // Uncomment for debugging
      // print('🔵 Status Code: ${response.statusCode}');
      // print('🔵 Full Response: ${response.data}');
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        final hasSubscription = response.data['has_subscription'] ?? false;
        // print('🟢 Extracted data: $data');
        if (data != null && data.isNotEmpty && hasSubscription) {
          return SubscriptionModel.fromJson(data);
        } else {
          // Return a default empty subscription model when no subscription exists
          return SubscriptionModel(
            id: 0,
            status: 'none',
            startDate: '',
            endDate: null,
            pricePaid: '0',
            isActive: false,
            package: PackageModel(
              id: 0,
              name: 'لا يوجد اشتراك',
              isTrial: false,
              maxTasks: 0,
              maxMilestonesPerTask: 0,
            ),
            usage: UsageModel(
              tasksCreated: 0,
              remainingTasks: 0,
              usagePercentage: 0,
            ),
            daysRemaining: 0,
          );
        }
      } else {
        throw ServerException(
          message: 'فشل في جلب الاشتراك الحالي: حالة الاستجابة ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.message ?? 'خطأ في الاتصال بالخادم: ${e.response?.statusCode ?? "غير معروف"}',
      );
    } catch (e) {
      throw ServerException(
        message: 'خطأ غير متوقع: ${e.toString()}',
      );
    }
  }
}
