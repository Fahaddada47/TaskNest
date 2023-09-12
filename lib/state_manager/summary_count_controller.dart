import 'package:get/get.dart';
import 'package:todo_app/data/models/network_response.dart';
import 'package:todo_app/data/models/summary_count_model.dart';
import 'package:todo_app/data/services/network_caller.dart';
import 'package:todo_app/data/utils/urls.dart';

class SummaryCountController extends GetxController {
  bool _getCountSummaryInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  bool get getCountSummaryInProgress => _getCountSummaryInProgress;
  SummaryCountModel get summaryCountModel => _summaryCountModel;


  Future<bool> getCountSummary() async {
    _getCountSummaryInProgress = true;
    update();
    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCount);
    _getCountSummaryInProgress = false;
    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
      update();
      return true;
    } else {
      update();
      return false;
    }

  }
}
