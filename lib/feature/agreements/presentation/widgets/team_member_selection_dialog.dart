import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/agreements/domain/entities/team_member.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/team_members_state.dart';

class TeamMemberSelectionDialog extends StatefulWidget {
  final List<TeamMember> initialSelectedMembers;
  final Function(List<TeamMember>) onSelectionDone;

  const TeamMemberSelectionDialog({
    super.key,
    required this.initialSelectedMembers,
    required this.onSelectionDone,
  });

  @override
  State<TeamMemberSelectionDialog> createState() =>
      _TeamMemberSelectionDialogState();
}

class _TeamMemberSelectionDialogState extends State<TeamMemberSelectionDialog> {
  bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (e) {
      return false;
    }
    return uri.isScheme('HTTP') || uri.isScheme('HTTPS');
  }

  late List<TeamMember> _tempSelectedMembers;

  @override
  void initState() {
    super.initState();
    _tempSelectedMembers = List.from(widget.initialSelectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختيار أعضاء الفريق'),
      content: BlocBuilder<TeamMembersCubit, TeamMembersState>(
        builder: (context, state) {
          if (state is TeamMembersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamMembersLoaded) {
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  final member = state.members[index];
                  final isSelected = _tempSelectedMembers.any((m) => m.id == member.id);
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _isValidUrl(member.avatarUrl) 
                              ? NetworkImage(member.avatarUrl!)
                              : null,
                          child: !_isValidUrl(member.avatarUrl)
                              ? const Icon(Icons.person, size: 20)
                              : null,
                        ),
                        SizedBox(width: 10),
                        Text(member.name),
                      ],
                    ),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _tempSelectedMembers.add(member);
                        } else {
                          _tempSelectedMembers.removeWhere((m) => m.id == member.id);
                        }
                      });
                    },
                  );
                },
              ),
            );
          } else if (state is TeamMembersError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('الرجاء المحاولة مرة أخرى'));
          }
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSelectionDone(_tempSelectedMembers);
            Navigator.of(context).pop();
          },
          child: const Text('تم'),
        ),
      ],
    );
  }
}
