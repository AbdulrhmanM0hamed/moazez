import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/usecases/usecase.dart';
import 'package:moazez/feature/invitations/domain/usecases/get_sent_invitations_usecase.dart';
import 'package:moazez/feature/invitations/domain/usecases/send_invitation_usecase.dart';
import 'package:moazez/feature/invitations/presentation/cubit/invitation_state.dart';

class InvitationCubit extends Cubit<InvitationState> {
  final SendInvitationUseCase sendInvitationUseCase;
  final GetSentInvitationsUseCase getSentInvitationsUseCase;

  InvitationCubit({
    required this.sendInvitationUseCase,
    required this.getSentInvitationsUseCase,
  }) : super(InvitationInitial());

  Future<void> sendInvitation(String email) async {
    emit(InvitationLoading());
    final result = await sendInvitationUseCase(email);
    result.fold(
      (failure) => emit(InvitationError(message: failure.message)),
      (invitation) => emit(InvitationSent(invitation: invitation)),
    );
  }

  Future<void> getSentInvitations() async {
    emit(InvitationLoading());
    final result = await getSentInvitationsUseCase(NoParams());
    result.fold(
      (failure) => emit(InvitationError(message: failure.message)),
      (invitations) => emit(SentInvitationsLoaded(invitations: invitations)),
    );
  }
}
