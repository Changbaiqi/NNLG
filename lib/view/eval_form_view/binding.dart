import 'package:get/get.dart';

import 'logic.dart';

class EvalFormViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EvalFormViewLogic());
  }
}
