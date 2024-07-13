import 'package:get/get.dart';

import 'logic.dart';

class SoftwareDevelopmentTestViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SoftwareDevelopmentTestViewLogic());
  }
}
