import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseSharedViewLogic());
  }
}
