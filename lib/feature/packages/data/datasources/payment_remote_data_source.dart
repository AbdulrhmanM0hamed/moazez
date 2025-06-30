import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';

abstract class PaymentRemoteDataSource {
  Future<Map<String, dynamic>> initiatePayment(int packageId);
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final Dio dio;

  PaymentRemoteDataSourceImpl({required this.dio});

  @override
  Future<Map<String, dynamic>> initiatePayment(int packageId) async {
    // تحديد عدد المحاولات والتأخير بين المحاولات
    int maxRetries = 3;
    int currentRetry = 0;
    int delayMs = 2000; // تأخير أولي 2 ثانية
    
    while (currentRetry < maxRetries) {
      try {
        // Debug logs for request
        debugPrint('[PaymentRemoteDataSource] Initiating payment for packageId: $packageId, attempt: ${currentRetry + 1}');
        debugPrint('[PaymentRemoteDataSource] Endpoint: ${ApiEndpoints.baseUrl}payment/mobile-init');
        
        final response = await dio.post(
          '${ApiEndpoints.baseUrl}payment/mobile-init',
          data: {'package_id': packageId},
          options: Options(
            headers: {
              'Authorization': 'Bearer ${await sl<CacheService>().getToken()}',
            },
            // تعيين validateStatus لقبول جميع الاستجابات للتعامل معها يدويًا
            validateStatus: (status) => true,
          ),
        );
        
        // Debug logs for response
        debugPrint('[PaymentRemoteDataSource] Response status: ${response.statusCode}');
        debugPrint('[PaymentRemoteDataSource] Response data: ${response.data}');

        // التحقق من حالة الاستجابة
        if (response.statusCode == 200 && response.data != null) {
          return response.data;
        } else if (response.statusCode == 429) {
          // Too Many Requests - زيادة التأخير وإعادة المحاولة
          currentRetry++;
          if (currentRetry < maxRetries) {
            debugPrint('[PaymentRemoteDataSource] Rate limited (429), retrying in ${delayMs}ms...');
            // إظهار رسالة تشخيصية أكثر تفصيلاً
            debugPrint('[PaymentRemoteDataSource] Rate limit message: ${response.data?['message'] ?? "No message provided"}');
            await Future.delayed(Duration(milliseconds: delayMs));
            delayMs *= 3; // مضاعفة وقت الانتظار بشكل أكبر في كل محاولة
            continue;
          } else {
            // استخراج رسالة الخطأ من الاستجابة إذا كانت متوفرة
            final errorMessage = response.data?['message'] ?? 'تم تجاوز الحد المسموح به من الطلبات';
            debugPrint('[PaymentRemoteDataSource] Rate limit exceeded after $maxRetries attempts. Error: $errorMessage');
            throw ServerException(
              message: 'لقد قمت بالعديد من المحاولات. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.',
            );
          }
        } else {
          throw ServerException(
            message: 'فشل في بدء عملية الدفع: حالة الاستجابة ${response.statusCode}',
          );
        }
      } on DioException catch (e) {
        debugPrint('[PaymentRemoteDataSource] DioException: ${e.message}, statusCode: ${e.response?.statusCode}');
        
        // التحقق من نوع الخطأ
        if (e.response?.statusCode == 429) {
          // Too Many Requests - زيادة التأخير وإعادة المحاولة
          currentRetry++;
          if (currentRetry < maxRetries) {
            debugPrint('[PaymentRemoteDataSource] Rate limited (429) in DioException, retrying in ${delayMs}ms...');
            // إظهار رسالة تشخيصية أكثر تفصيلاً
            debugPrint('[PaymentRemoteDataSource] Rate limit response data: ${e.response?.data}');
            await Future.delayed(Duration(milliseconds: delayMs));
            delayMs *= 3; // مضاعفة وقت الانتظار بشكل أكبر في كل محاولة
            continue;
          } else {
            // استخراج رسالة الخطأ من الاستجابة إذا كانت متوفرة
            final errorMessage = e.response?.data?['message'] ?? 'تم تجاوز الحد المسموح به من الطلبات';
            debugPrint('[PaymentRemoteDataSource] Rate limit exceeded in DioException after $maxRetries attempts. Error: $errorMessage');
            throw ServerException(
              message: 'لقد قمت بالعديد من المحاولات. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.',
            );
          }
        }
        
        // استخدام معالج الأخطاء الموحد
        final failure = handleDioException(e);
        throw ServerException(message: failure.message);
      } catch (e) {
        debugPrint('[PaymentRemoteDataSource] Unknown error: ${e.toString()}');
        throw ServerException(
          message: 'خطأ غير متوقع: ${e.toString()}',
        );
      }
    }
    
    // إذا وصلنا إلى هنا، فهذا يعني أننا استنفدنا جميع المحاولات
    debugPrint('[PaymentRemoteDataSource] All retry attempts exhausted');
    throw ServerException(
      message: 'فشل في بدء عملية الدفع بعد عدة محاولات. يرجى الانتظار لمدة 5 دقائق قبل المحاولة مرة أخرى.',
    );
  }
}
