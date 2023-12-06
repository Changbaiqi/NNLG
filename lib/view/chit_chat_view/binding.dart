import 'package:get/get.dart';

import 'logic.dart';

class ChitChatViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChitChatViewLogic());
  }
}
