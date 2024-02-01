import 'package:get/get.dart';
import 'package:nnlg/utils/ExamInquiryUtil.dart';

import 'state.dart';

class ExamInquiryViewLogic extends GetxController {
  final ExamInquiryViewState state = ExamInquiryViewState();



  //初始化列表
  initSearchList() {
    ExamInquiryUtil().getReportCardQueryList().then((value) {
      state.searList.value = value;
      state.searList.refresh();
    });
  }

  //通过日期选择相关成绩展示
  showScoreList(String time) async {
    if (time == '全部学期') time = '';
    state.showState.value =0;
    await ExamInquiryUtil().getExamList(time).then((value) {
      state.scoreList.value = value;
      state.showState.value=1;
    });
  }

  @override
  void onInit() {
    ExamInquiryUtil().getExamNowSelectTime().then((value){
      state.selectTime.value = value;
      initSearchList();
      showScoreList(state.selectTime.value);
    });
  }
}
