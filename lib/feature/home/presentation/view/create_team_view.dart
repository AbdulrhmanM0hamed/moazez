import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/feature/home/presentation/cubit/team_cubit.dart';
import 'package:moazez/feature/home/presentation/widgets/create_team_section.dart';

class CreateTeamView extends StatelessWidget {
  const CreateTeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'إنشاء فريق',
       
      ),
      body: const SingleChildScrollView(
        child: CreateTeamSection(),
      ),
    );
  }
}
