import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/agreements/presentation/view/add_task_view.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreements_view_body.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';

class AgreementsView extends StatelessWidget {
  const AgreementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MemberStatsCubit>()..fetchMemberTaskStats(),
      child: Builder(builder: (context) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<MemberStatsCubit>().fetchMemberTaskStats();
            },
            child: const AgreementsViewBody(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddTaskView.routeName);
            },
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            tooltip: 'إضافة مهمة',
            child: const Icon(Icons.add_task, color: Colors.white, size: 28),
          ),
        );
      }),
    );
  }
}
