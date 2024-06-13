import 'package:get/get.dart';

import 'logic.dart';

class AccountSafeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountSafeViewLogic());
  }
}
