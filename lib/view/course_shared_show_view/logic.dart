import 'package:get/get.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';

import 'state.dart';

class CourseSharedShowViewLogic extends GetxController {
  final CourseSharedShowViewState state = CourseSharedShowViewState();

  @override
  void onInit() {
    state.accountData.value = Get.arguments['data']; //初始化账号数据
  }
}
