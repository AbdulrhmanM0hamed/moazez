import 'package:moazez/feature/MyTasks/data/models/my_task_model.dart';

abstract class MyTasksRemoteDataSource {
  Future<List<MyTaskModel>> getMyTasks({String? status});
}
