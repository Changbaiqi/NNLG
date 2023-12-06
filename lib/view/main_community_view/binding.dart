import 'package:get/get.dart';

import 'logic.dart';

class MainCommunityViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainCommunityViewLogic());
  }
}
