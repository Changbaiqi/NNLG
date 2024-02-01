import 'package:get/get.dart';

import 'logic.dart';

class TrainPlanViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainPlanViewLogic());
  }
}
