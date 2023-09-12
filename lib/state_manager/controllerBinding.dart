import 'package:get/get.dart';
import 'package:todo_app/state_manager/delete_task_controller.dart';
import 'package:todo_app/state_manager/login_controller.dart';
import 'package:todo_app/state_manager/summary_count_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController());
    Get.put<SummaryCountController>(SummaryCountController());
    Get.put<DeleteTaskController>(DeleteTaskController());
  }
}
