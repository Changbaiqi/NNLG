import 'package:get/get.dart';

import 'logic.dart';

class TeachingEvaViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TeachingEvaViewLogic());
  }
}
