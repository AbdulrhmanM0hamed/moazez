import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/team_state.dart';

class TeamMemberSelectionDialog extends StatefulWidget {
  final List<TeamMemberModel> initialSelectedMembers;
  final Function(List<TeamMemberModel>) onSelectionDone;

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

  late List<TeamMemberModel> _tempSelectedMembers;

  @override
  void initState() {
    super.initState();
    _tempSelectedMembers = List.from(widget.initialSelectedMembers);
    context.read<TeamCubit>().fetchTeamMembers();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('اختيار أعضاء الفريق'),
      content: BlocBuilder<TeamCubit, TeamState>(
        builder: (context, state) {
          if (state is TeamMembersLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TeamMembersLoaded) {
            if (state.members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'لا يوجد أعضاء في الفريق حالياً',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<TeamCubit>().fetchTeamMembers();
                      },
                      child: const Text('تحديث القائمة'),
                    ),
                  ],
                ),
              );
            }
            return SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.members.length,
                itemBuilder: (context, index) {
                  final member = state.members[index];
                  final isSelected = _tempSelectedMembers.any(
                    (m) => m.id == member.id,
                  );
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          child: _isValidUrl(member.avatarUrl)
                              ? CustomCachedNetworkImage(
                                  imageUrl: member.avatarUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  borderRadius: BorderRadius.circular(20),
                                )
                              : SvgPicture.asset(
                                  'assets/images/defualt_avatar.svg',
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        const SizedBox(width: 10),
                        Text(member.name),
                      ],
                    ),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _tempSelectedMembers.add(member);
                        } else {
                          _tempSelectedMembers.removeWhere(
                            (m) => m.id == member.id,
                          );
                        }
                      });
                    },
                  );
                },
              ),
            );
          } else if (state is TeamMembersError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.message.contains('403')
                        ? 'لا يوجد أعضاء في الفريق حالياً'
                        : state.message,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TeamCubit>().fetchTeamMembers();
                    },
                    child: const Text('تحديث القائمة'),
                  ),
                ],
              ),
            );
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
