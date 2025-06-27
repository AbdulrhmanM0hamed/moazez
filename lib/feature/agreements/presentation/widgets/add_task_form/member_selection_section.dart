import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_cubit.dart';
import 'package:moazez/feature/agreements/presentation/widgets/custom_task_text_field.dart';
import 'package:moazez/feature/agreements/presentation/widgets/team_member_selection_dialog.dart';

class MemberSelectionSection extends StatelessWidget {
  final List<TeamMember> selectedMembers;
  final Function(List<TeamMember>) onMembersSelected;

  const MemberSelectionSection({
    super.key,
    required this.selectedMembers,
    required this.onMembersSelected,
  });

  void _showMemberSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: context.read<TeamMembersCubit>(),
        child: TeamMemberSelectionDialog(
          initialSelectedMembers: selectedMembers,
          onSelectionDone: (selected) {
            onMembersSelected(selected);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showMemberSelectionDialog(context),
      child: AbsorbPointer(
        child: CustomTaskTextField(
          controller: TextEditingController(
            text: selectedMembers.map((e) => e.name).join(', '),
          ),
          labelText: 'الأعضاء المختارون',
          prefixIcon: Icons.group,
          validator: (value) => selectedMembers.isEmpty
              ? 'الرجاء اختيار عضو واحد على الأقل'
              : null,
        ),
      ),
    );
  }
}
