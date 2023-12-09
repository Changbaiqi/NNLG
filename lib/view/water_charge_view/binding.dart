import 'package:get/get.dart';

import 'logic.dart';

class WaterChargeViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WaterChargeViewLogic());
  }
}
