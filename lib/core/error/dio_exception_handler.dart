import 'package:dio/dio.dart';
import 'package:moazez/core/error/failures.dart';

Failure handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(message: 'انتهت مهلة الاتصال. يرجى التحقق من اتصالك بالإنترنت');
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad Request
          return ServerFailure(message: e.response?.data['message'] ?? 'طلب غير صالح');
        case 401: // Unauthorized
          return UnauthorizedFailure(message: 'غير مصرح، يرجى التأكد من صحة البريد الإلكتروني أو كلمة المرور');
        case 404: // Not Found
          return ServerFailure(message: 'المورد المطلوب غير موجود');
        case 422: // Unprocessable Entity (Validation Error)
          return ValidationFailure(message: e.response?.data['message'] ?? 'خطأ في التحقق من البيانات', validationErrors: e.response?.data['errors']);
        case 500: // Internal Server Error
        default:
          return ServerFailure(message: 'حدث خطأ داخلي في الخادم');
      }
    case DioExceptionType.cancel:
      return const ServerFailure(message: 'تم إلغاء الطلب');
    case DioExceptionType.unknown:
    default:
      return const NetworkFailure(message: 'لا يوجد اتصال بالإنترنت أو حدث خطأ في الشبكة');
  }
}
