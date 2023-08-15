import 'package:flutter/material.dart';
import 'package:todo_app/data/models/network_response.dart';
import 'package:todo_app/data/models/task_list_model.dart';
import 'package:todo_app/data/services/network_caller.dart';
import 'package:todo_app/data/utils/urls.dart';
import 'package:todo_app/ui/widgets/task_list_tile.dart';
import 'package:todo_app/ui/widgets/user_profile_banner.dart';


class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({Key? key}) : super(key: key);

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getProgressTasksInProgress = false;
  TaskListModel _taskListModel = TaskListModel();

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getInProgressTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          // children: [
          //   const UserProfileAppBar(),
          //   Expanded(
          //     child: _getProgressTasksInProgress
          //         ? const Center(
          //       child: CircularProgressIndicator(),
          //     )
          //         : ListView.separated(
          //       itemCount: _taskListModel.data?.length ?? 0,
          //       itemBuilder: (context, index) {
          //         return TaskListTile(
          //           data: _taskListModel.data![index],
          //           onDeleteTap: () {},
          //           onEditTap: () {},
          //         );
          //       },
          //       separatorBuilder: (BuildContext context, int index) {
          //         return const Divider(
          //           height: 4,
          //         );
          //       },
          //     ),
          //   ),
          // ],
        ),
      ),
    );
  }
}