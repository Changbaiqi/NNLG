import 'package:get/get.dart';

import 'logic.dart';

class EvaDetailViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EvaDetailViewLogic());
  }
}
