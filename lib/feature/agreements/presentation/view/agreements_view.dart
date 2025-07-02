import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/feature/agreements/presentation/view/add_task_view.dart';
import 'package:moazez/feature/agreements/presentation/widgets/agreements_view_body.dart';
import 'package:moazez/feature/home_supporter/presentation/cubit/member_stats_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/close_task_cubit.dart';
import 'package:moazez/feature/agreements/presentation/cubit/close_task_state.dart';
import 'package:moazez/core/utils/widgets/custom_snackbar.dart';

class AgreementsView extends StatelessWidget {
  const AgreementsView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<MemberStatsCubit>()..fetchMemberTaskStats(),
        ),
        BlocProvider(
          create: (context) => sl<CloseTaskCubit>(),
        ),
      ],
      child: Builder(builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            // إغلاق التطبيق عند الضغط على زر الرجوع من الصفحة الرئيسية
            await SystemNavigator.pop();
            return false;
          },
          child: Scaffold(
            body: BlocListener<CloseTaskCubit, CloseTaskState>(
              listener: (context, state) {
              if (state is CloseTaskSuccess) {
                CustomSnackbar.showSuccess(
                  context: context,
                  message: state.message,
                );
                context.read<MemberStatsCubit>().fetchMemberTaskStats();
              } else if (state is CloseTaskFailure) {
                CustomSnackbar.showError(
                  context: context,
                  message: state.message,
                );
              }
            },
            child: RefreshIndicator(
            onRefresh: () async {
              context.read<MemberStatsCubit>().fetchMemberTaskStats();
            },
            child: const AgreementsViewBody(),
          ),), 
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
        ));
      }),
    );
  }
}
