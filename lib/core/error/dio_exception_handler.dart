import 'package:dio/dio.dart';
import 'package:moazez/core/error/failures.dart';

Failure handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
    case DioExceptionType.unknown:
    case DioExceptionType.badCertificate:
      return const NetworkFailure(
        message: 'لا يوجد اتصال بالانترنت او حدث خطأ فى الشبكة !',
      );

    case DioExceptionType.cancel:
      return const ServerFailure(message: 'تم إلغاء الطلب');

    case DioExceptionType.badResponse:
      return _handleBadResponse(e);
  }
}

Failure _handleBadResponse(DioException e) {
  switch (e.response?.statusCode) {
    case 400:
      return ServerFailure(
        message: e.response?.data['message'] ?? 'طلب غير صالح',
      );
    case 401:
      return UnauthorizedFailure(
        message:
            e.response?.data['message'] ?? 'بيانات الاعتماد المقدمة غير صحيحة',
      );
    case 404:
      return ServerFailure(message: 'المورد المطلوب غير موجود');
    case 422:
      return ValidationFailure(
        message: e.response?.data['message'] ?? 'خطأ في التحقق من البيانات',
        validationErrors: e.response?.data['errors'],
      );
    case 429:
      return ValidationFailure(
        message: e.response?.data['message'] ?? 'عدد الطلبات المسموح بها انتهت',
        validationErrors: e.response?.data['errors'],
      );
    default:
      return ServerFailure(
        message: e.response?.data['message'] ?? 'حدث خطأ داخلي في الخادم',
      );
  }
}
