import 'dart:collection';

import 'package:get/get.dart';
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';
import 'package:nnlg/utils/edusys/tools/TrainPlan.dart';
import 'package:nnlg/web/TrainPlanWeb.dart';

import 'state.dart';

class TrainPlanViewLogic extends GetxController {
  final TrainPlanViewState state = TrainPlanViewState();



  Future<LinkedHashMap<String, List<TrainPlanInForm>>> getTrainPlanMap() async{
    LinkedHashMap<String, List<TrainPlanInForm>> map= LinkedHashMap();
    await TrainPlanWeb().getTrainPlan().then((List<TrainPlanInForm> value) {
      value.forEach((TrainPlanInForm element) {
        if(!map.containsKey('${element.semester}')){
          map['${element.semester}'] = [];
        }
        map['${element.semester}']?.add(element);
      });
    });
    // print(map);
    return map;
  }

  @override
  void onInit() {
     getTrainPlanMap().then((value) => state.mapList.value=value );//初始化数据
  }
}
