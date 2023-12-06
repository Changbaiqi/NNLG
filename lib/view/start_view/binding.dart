import 'package:get/get.dart';

import 'logic.dart';

class StartViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StartViewLogic());
  }
}
