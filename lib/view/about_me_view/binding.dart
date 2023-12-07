import 'package:get/get.dart';

import 'logic.dart';

class AboutMeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AboutMeViewLogic());
  }
}
