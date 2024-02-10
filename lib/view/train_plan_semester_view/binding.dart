import 'package:get/get.dart';

import 'logic.dart';

class TrainPlanSemesterViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainPlanSemesterViewLogic());
  }
}
