import 'package:get/get.dart';

import 'logic.dart';

class CourseSetViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseSetViewLogic());
  }
}
