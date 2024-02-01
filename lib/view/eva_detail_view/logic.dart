import 'package:get/get.dart';
import 'package:nnlg/utils/TeachingEvaUtil.dart';

import 'state.dart';

class EvaDetailViewLogic extends GetxController {
  final EvaDetailViewState state = EvaDetailViewState();


  //通过日期选择相关评教展示
  showEvaDetailList() async {
    state.showState.value=0;
  await TeachingEvaUtil().getEvaDetailList(Get.arguments['url']).then((value) => value.forEach((element) {
        // print(element.toJson());
       state.searList.value.add(element.toJson());
    }));
    state.showState.value = 1;
  }







  @override
  void onInit() {
    showEvaDetailList();
    // TeachingEvaUtil().getTeachingEvaList().then((value) => value.forEach((element) {
    //   // print(element.toJson());
    //   TeachingEvaUtil().getEvaDetailList(element).then((value) => value.forEach((element) {
    //     // print(element.toJson());
    //     TeachingEvaUtil().getEvaDetailForm(element);
    //   }));
    // }));
  }

}
