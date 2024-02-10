import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedChooseViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseSharedChooseViewLogic());
  }
}
