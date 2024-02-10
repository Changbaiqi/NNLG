import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedShowViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseSharedShowViewLogic());
  }
}
