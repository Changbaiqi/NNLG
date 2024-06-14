import 'dart:developer';

import 'package:get/get.dart';
import 'package:nnlg/utils/TeachingEvaUtil.dart';
import 'package:nnlg/utils/edusys/entity/EvalInform.dart';

import 'state.dart';

class EvalFormViewLogic extends GetxController {
  final EvalFormViewState state = EvalFormViewState();

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 检查是否全部选择，全选则true，没有则false
   * [date] 14:49 2024/6/14
   * [param] null
   * [return]
   */
  bool checkSubmit(json){
    for(var classList in json['classList']) {
      for (var problemList in classList['problemList']) {
        bool flag =false;
        for (var selectList in problemList['selectList']) {
          if (selectList['checked']) {flag = true;}
        }
        if(!flag) return false;
      }
    }
    return true;
  }

  @override
  void onInit() {
     TeachingEvaUtil().getEvaDetailForm(EvalInform(url: Get.arguments['url'])).then((value) {state.formJsonData.value = value; state.formJsonData.refresh();});

    // log(Get.arguments.toString());
  }
}
