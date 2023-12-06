import 'package:get/get.dart';

import 'logic.dart';

class MainUserViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainUserViewLogic());
  }
}
