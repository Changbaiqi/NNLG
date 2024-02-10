import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/view/router/Routes.dart';

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
          : ListView.builder(
              itemCount: state.mapList.value.length,
              itemBuilder: (BuildContext context, int index) {
                List<String> keys = state.mapList.value.keys.toList();
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 350),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: listChild(keys[index],
                          state.translate.value[state.total.value++]),
                    ),
                  ),
                );
              },
            )),
    );
  }

  //学期列表选项
  Widget listChild(String semester, String translate) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: InkWell(
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
                Positioned(
                    left: 40,
                    top: 10,
                    child: Text(
                      '$semester',
                      style: TextStyle(fontSize: 18),
                    )),
                Positioned(
                    left: 40,
                    top: 35,
                    child: Text(
                      '人话：$translate',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    )),
                Visibility(
                    visible: CourseData.nowCourseList.value == '$semester'
                        ? true
                        : false,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/images/position.json',
                                  width: 35),
                              Text('当前课表',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54))
                            ],
                          ),
                        )))
              ],
            ),
          ),
        ),
        onTap: () {
          Get.toNamed(Routes.TrainPlanSemester, arguments: {
            'semester': semester,
            'translate': translate,
            'dataList': state.mapList.value['${semester}']
          });
        },
      ),
    );
  }
}
