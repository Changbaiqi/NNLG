import 'package:get/get.dart';

import 'state.dart';

class TrainPlanSemesterViewLogic extends GetxController {
  final TrainPlanSemesterViewState state = TrainPlanSemesterViewState();

  /**
   * [title]
   * [author] 长白崎
   * [description] 初始化数据
   * [date] 14:59 2024/2/2
   * [param] null
   * [return]
   */
  initData(){
    state.semester.value = Get.arguments['semester']; //学期年份
    state.translate.value = Get.arguments['translate']; //学期名称
    state.dataList.value = Get.arguments['dataList']; //初始化数据列表
  }
  @override
  void onInit() {
    initData();
  }
}
