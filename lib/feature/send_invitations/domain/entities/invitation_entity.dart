class InvitationEntity {
  final int id;
  final String email;
  final String status;
  final String sentAt;
  final String? acceptedAt;

  const InvitationEntity({
    required this.id,
    required this.email,
    required this.status,
    required this.sentAt,
    this.acceptedAt,
  });
}
