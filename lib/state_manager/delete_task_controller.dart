import 'package:get/get.dart';
import 'package:todo_app/data/models/network_response.dart';
import 'package:todo_app/data/models/task_list_model.dart';
import 'package:todo_app/data/services/network_caller.dart';
import 'package:todo_app/data/utils/urls.dart';

class DeleteTaskController extends GetxController{
  TaskListModel _taskListModel = TaskListModel();
  TaskListModel get taskListModel => _taskListModel;


  Future<bool> deleteTask(String taskId) async {
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.deleteTask(taskId));
    if (response.isSuccess) {
        _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      return true;
    } else {
      update();
      return true;
    }
  }
}