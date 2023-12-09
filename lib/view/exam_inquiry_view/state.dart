import 'package:get/get.dart';

class ExamInquiryViewState {
  final searList = <String>[].obs;
  final selectTime = '全部学期'.obs; //栋号选择
  final scoreList = <String>[].obs; //分数list


  final showState = 0.obs; //展示状态，0代表加载中，1代表加载完毕

  ExamInquiryViewState() {
    ///Initialize variables
  }
}
