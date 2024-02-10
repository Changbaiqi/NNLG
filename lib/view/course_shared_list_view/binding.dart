import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedListViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CourseSharedListViewLogic());
  }
}
