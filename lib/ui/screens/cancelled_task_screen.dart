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

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();
  final DeleteTaskController _deleteTaskController =
  Get.find<DeleteTaskController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getCancelledTasks();
    });
  }


  Future<void> getCancelledTasks() async {
    _getCancelledTasksInProgress = true;
    if (mounted) {
      setState(() {});
    }
    final NetworkResponse response =
    await NetworkCaller().getRequest(Urls.canceledTasks);
    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);

    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Canceled tasks fetch failed')),
        );
      }
    }
    _getCancelledTasksInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }





  void showStatusUpdateBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(
          task: task,
          onUpdate: () {
            getCancelledTasks();
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
              child: _getCancelledTasksInProgress
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


