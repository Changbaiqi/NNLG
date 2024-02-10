import 'dart:collection';

import 'package:get/get.dart';
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';

class TrainPlanViewState {

  final translate = ["大一上学期","大一下学期","大二上学期","大二下学期","大三上学期","大三下学期","大四上学期","大四下学期","大五上学期","大五下学期"].obs;
  final total = 0.obs;
  final mapList = LinkedHashMap<String, List<TrainPlanInForm>>().obs; //数据

  TrainPlanViewState() {
    ///Initialize variables
  }
}
