import 'package:get/get.dart';

import 'logic.dart';

class NnlgCommunityViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NnlgCommunityViewLogic());
  }
}
