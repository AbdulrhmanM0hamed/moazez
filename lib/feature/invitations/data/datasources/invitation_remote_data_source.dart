import 'package:dio/dio.dart';
import 'package:moazez/core/error/exceptions.dart';
import 'package:moazez/core/services/cache/cache_service.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/api_endpoints.dart';
import 'package:moazez/feature/invitations/data/models/invitation_model.dart';
import 'package:moazez/feature/invitations/data/models/received_invitation_model.dart';

abstract class InvitationRemoteDataSource {
  Future<InvitationModel> sendInvitation(String email);
  Future<List<InvitationModel>> getSentInvitations();
  Future<List<ReceivedInvitationModel>> getReceivedInvitations();
  Future<bool> respondToInvitation(String invitationId, String action);
}

class InvitationRemoteDataSourceImpl implements InvitationRemoteDataSource {
  final Dio dio;

  InvitationRemoteDataSourceImpl({required this.dio});

  @override
  Future<InvitationModel> sendInvitation(String email) async {
    try {
      final token = await sl<CacheService>().getToken();
      print('Token used for Invitation API: $token');
      final response = await dio.post(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.sendInvitation}',
        data: {'email': email},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token ?? ""}',
          },
        ),
      );
      print(
        'Send Invitation API Response: ${response.statusCode} - ${response.data}',
      );
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        final data = response.data['data'] ?? response.data['join_request'];
        if (data != null) {
          print('Invitation Data to Parse: $data');
          return InvitationModel.fromJson(data);
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
      } else {
        throw ServerException(message: 'فشل في إرسال الدعوة');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<InvitationModel>> getSentInvitations() async {
    try {
      final token = await sl<CacheService>().getToken();
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.teamInvitations}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token ?? ""}',
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        if (data != null && data is List) {
          return data.map((json) => InvitationModel.fromJson(json)).toList();
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
      } else {
        throw ServerException(message: 'فشل في جلب الدعوات المرسلة');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<ReceivedInvitationModel>> getReceivedInvitations() async {
    try {
      final token = await sl<CacheService>().getToken();
      final response = await dio.get(
        '${ApiEndpoints.baseUrl}${ApiEndpoints.myInvitations}',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token ?? ""}',
          },
        ),
      );
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        print('Received Invitations Data: ${response.data}');
        if (data != null && data is List) {
          print('Received Invitations Data: ${data}');
          return data
              .map((json) => ReceivedInvitationModel.fromJson(json))
              .toList();
        } else {
          throw ServerException(
            message: 'البيانات المسترجعة غير صحيحة أو فارغة',
          );
        }
      } else {
        throw ServerException(message: 'فشل في جلب طلبات الانضمام المستلمة');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> respondToInvitation(String invitationId, String action) async {
    try {
      final token = await sl<CacheService>().getToken();
      final response = await dio.post(
        ApiEndpoints.invitationRespond,
        data: {'invitation_id': invitationId, 'action': action},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${token ?? ""}',
          },
        ),
      );
      print('Respond to Invitation API Response: ${response.statusCode} - ${response.data}');
      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data != null) {
        return true;
      } else {
        throw ServerException(message: 'فشل في الرد على الدعوة: ${response.data?.toString() ?? "لا توجد تفاصيل"}');
      }
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'خطأ في الاتصال بالخادم');
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
