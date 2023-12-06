import 'package:get/get.dart';

import 'logic.dart';

class MainWaterViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainWaterViewLogic());
  }
}
