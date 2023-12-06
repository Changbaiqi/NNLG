import 'package:get/get.dart';

import 'logic.dart';

class MainCourseViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainCourseViewLogic());
  }
}
