import 'package:get/get.dart';

import 'logic.dart';

class CardMessageSetViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CardMessageSetViewLogic());
  }
}
