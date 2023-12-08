import 'package:get/get.dart';

import 'logic.dart';

class ScoreInquiryViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ScoreInquiryViewLogic());
  }
}
