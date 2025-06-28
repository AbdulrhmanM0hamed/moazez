import 'package:moazez/feature/agreements/data/models/task_details_model.dart';
import 'package:moazez/feature/agreements/data/models/team_member_model.dart';

import 'package:moazez/feature/agreements/data/models/task_model.dart';

abstract class AgreementsRemoteDataSource {
  Future<List<TeamMemberModel>> getTeamMembers();
  Future<void> createTask(TaskModel task);
  Future<String> closeTask({required String taskId, required String status});
  Future<TaskDetailsModel> getTaskDetails({required int taskId});
}
