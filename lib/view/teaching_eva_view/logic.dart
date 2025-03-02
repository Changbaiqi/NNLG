import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/utils/TeachingEvaUtil.dart';

import 'state.dart';

class TeachingEvaViewLogic extends GetxController {
  final TeachingEvaViewState state = TeachingEvaViewState();





  //通过日期选择相关评教展示
  showEvalList() async {
    state.showState.value=0;

    await TeachingEvaUtil().getTeachingEvaList().then((value) => value.forEach((element) {
      state.searList.value.add(element.toJson());
    }));
    state.showState.value = 1;
  }







  @override
  void onInit() {
    showEvalList();
    // TeachingEvaUtil().getTeachingEvaList().then((value) => value.forEach((element) {
    //   // print(element.toJson());
    //   TeachingEvaUtil().getEvaDetailList(element).then((value) => value.forEach((element) {
    //     // print(element.toJson());
    //     TeachingEvaUtil().getEvaDetailForm(element);
    //   }));
    // }));
  }
}
