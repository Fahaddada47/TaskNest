import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/data/models/network_response.dart';
import 'package:todo_app/data/models/task_list_model.dart';
import 'package:todo_app/data/services/network_caller.dart';
import 'package:todo_app/data/utils/urls.dart';
import 'package:todo_app/state_manager/delete_task_controller.dart';
import 'package:todo_app/ui/screens/update_task_status_sheet.dart';
import 'package:todo_app/ui/widgets/task_list_tile.dart';
import 'package:todo_app/ui/widgets/user_profile_banner.dart';


class InProgressTaskScreen extends StatefulWidget {
  const InProgressTaskScreen({Key? key}) : super(key: key);

  @override
  State<InProgressTaskScreen> createState() => _InProgressTaskScreenState();
}

class _InProgressTaskScreenState extends State<InProgressTaskScreen> {
  bool _getProgressTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();
  final DeleteTaskController _deleteTaskController =
  Get.find<DeleteTaskController>();



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInProgressTasks();
    });
  }


  Future<void> getInProgressTasks() async {
    _getProgressTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.inProgressTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('In progress tasks get failed')));
      }
    }
    _getProgressTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }
  //
  //
  // Future<void> deleteTask(String taskId) async {
  //   final NetworkResponse response =
  //   await NetworkCaller().getRequest(Urls.deleteTask(taskId));
  //   if (response.isSuccess) {
  //     setState(() {
  //       _taskListModel.data!.removeWhere((element) => element.sId == taskId);
  //     });
  //   } else {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Deletion of task failed')),
  //       );
  //     }
  //   }
  // }

  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(
          task: task,
          onUpdate: () {
            getInProgressTasks();
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const UserProfileAppBar(),
            Expanded(
              child: _getProgressTasksInProgress
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.separated(
                itemCount: _taskListModel.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return GetBuilder<DeleteTaskController>(
                      builder: (_) {
                        return TaskListTile(
                          data: _taskListModel.data![index],
                          onDeleteTap: () {
                            _deleteTaskController.deleteTask(_taskListModel.data![index].sId!);
                          },
                          onEditTap: () {
                            // showEditBottomSheet(_taskListModel.data![index]);
                            showStatusUpdateBottomSheet(
                                _taskListModel.data![index]);
                          },
                        );
                      }
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    height: 4,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}