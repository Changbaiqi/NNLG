import 'package:get/get.dart';

import 'logic.dart';

class MainCourseNewViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainCourseNewViewLogic());
  }
}
