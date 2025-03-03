import 'package:get/get.dart';

import 'logic.dart';

class WaterHelpViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterHelpViewLogic());
  }
}
