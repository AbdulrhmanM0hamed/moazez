import 'package:dio/dio.dart';
import 'package:moazez/core/error/dio_exception_handler.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/rewards/data/models/reward_model.dart';

abstract class RewardRemoteDataSource {
  Future<List<RewardModel>> getTeamRewards();
  Future<List<RewardModel>> getMyRewards();
}

class RewardRemoteDataSourceImpl implements RewardRemoteDataSource {
  final Dio dio;

  RewardRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<RewardModel>> getTeamRewards() async {
    final token = await sl<CacheService>().getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(ApiEndpoints.teamRewards);
    //  print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;
    //    print(data);
        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
      //  print(response.data);
        throw ServerException(message: 'فشل في تحميل البيانات');
      }
    } on DioException catch (e) {
     // print(e);
      throw handleDioException(e);
    } catch (e) {
     // print(e);
      throw ServerException(message: 'فشل في تحميل البيانات');
    }
  }

  Future<List<RewardModel>> getMyRewards() async {
    final token = await sl<CacheService>().getToken();
    dio.options.headers['Authorization'] = 'Bearer $token';
    try {
      final response = await dio.get(ApiEndpoints.myRewards);
   //   print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List;
     //   print(data);
        return data.map((json) => RewardModel.fromJson(json)).toList();
      } else {
     //   print(response.data);
        throw ServerException(message: 'فشل في تحميل البيانات');
      }
    } on DioException catch (e) {
    //  print(e);
      throw handleDioException(e);
    } catch (e) {
    //  print(e);
      throw ServerException(message: 'فشل في تحميل البيانات');
    }
  }
}
