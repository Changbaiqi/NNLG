import 'package:get/get.dart';

import 'logic.dart';

class AuthenticationStandardsViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthenticationStandardsViewLogic());
  }
}
