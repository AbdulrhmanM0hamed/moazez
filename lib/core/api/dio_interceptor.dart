// import 'package:dio/dio.dart';
// import 'package:moazez/core/services/cache_helper.dart';
// import 'package:moazez/core/services/service_locator.dart';

// class DioInterceptor extends Interceptor {
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     final token = sl<CacheHelper>().getAuthToken();

//     // Add Authorization token to header if it exists
//     if (token != null) {
//       options.headers['Authorization'] = 'Bearer $token';
//     }

//     // Set Accept header for all requests
//     options.headers['Accept'] = 'application/json';

//     super.onRequest(options, handler);
//   }
// }
