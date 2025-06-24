import 'package:moazez/feature/send_invitations/domain/entities/invitation_entity.dart';

class InvitationModel extends InvitationEntity {
  const InvitationModel({
    required int id,
    required String email,
    required String status,
    required String sentAt,
    String? acceptedAt,
  }) : super(
          id: id,
          email: email,
          status: status,
          sentAt: sentAt,
          acceptedAt: acceptedAt,
        );

  factory InvitationModel.fromJson(Map<String, dynamic> json) {
    return InvitationModel(
      id: json['id'],
      email: json['email'] ?? '',
      status: json['status'] ?? 'pending',
      sentAt: json['created_at'] ?? json['sent_at'] ?? '',
      acceptedAt: json['updated_at'] ?? json['accepted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'status': status,
      'sent_at': sentAt,
      'accepted_at': acceptedAt,
    };
  }
}
