import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/dao/CourseData.dart';

import 'logic.dart';

class TrainPlanViewPage extends StatelessWidget {
  TrainPlanViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TrainPlanViewLogic>();
  final state = Get.find<TrainPlanViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('培养计划'),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx(() => state.mapList.value.length == 0
          ? Center(
              child: Lottie.asset('assets/images/loading.json',
                  height: 200, width: 200))
          : ListView(
              children:
                  state.mapList.value.keys.map((e) => listChild(e)).toList(),
            )),
    );
  }

  //学期列表选项
  Widget listChild(String semester) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Card(
        child: Container(
          height: 60,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 40,
                  width: 5,
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                ),
              ),
              Positioned(left: 40, top: 20, child: Text('$semester')),
              Visibility(
                  visible: CourseData.nowCourseList.value == '$semester'
                      ? true
                      : false,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Text('当前课表对应学期'),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}
