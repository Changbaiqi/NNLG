import 'dart:collection';

import 'package:get/get.dart';
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';

class TrainPlanViewState {

  final mapList = LinkedHashMap<String, List<TrainPlanInForm>>().obs; //数据

  TrainPlanViewState() {
    ///Initialize variables
  }
}
