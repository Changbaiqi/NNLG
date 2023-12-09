import 'package:get/get.dart';

import 'logic.dart';

class ExamInquiryViewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExamInquiryViewLogic());
  }
}
