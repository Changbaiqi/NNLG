import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';

import 'logic.dart';

class TrainPlanSemesterViewPage extends StatelessWidget {
  TrainPlanSemesterViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TrainPlanSemesterViewLogic>();
  final state = Get.find<TrainPlanSemesterViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('${state.semester.value}', style: TextStyle(fontSize: 18)),
            Text(
              '${state.translate.value}',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            )
          ],
        ),
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: state.dataList.value.length,
        itemBuilder: (BuildContext context, int index) {
          // children: state.dataList.value.map((e) => showchildElement(e)).toList();
          return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 350),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: showchildElement(state.dataList.value[index]),
                ),
              ));
        },
      ),
    );
  }

  /**
   * 单个组件
   */
  Widget showchildElement(TrainPlanInForm trainPlanInForm) {
    // int colorR = 0;
    // int colorG = 0;
    // int colorB = 0;
    // while(true){
    //   colorR =Random().nextInt(255);
    //   colorG =Random().nextInt(255);
    //   colorB =Random().nextInt(255);
    //   if((colorR-colorG).abs()>=40 || (colorG-colorB).abs()>=40)
    //     break;
    // }

    //print(json);
    // json = jsonDecode(json);
    //var jsson = jsonDecode('{"name":"cc"}');
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Container(
        height: 220,
        // width: 150,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            // color: Color.fromARGB(255, colorR, colorG, colorB),
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black45, blurRadius: 10, offset: Offset(1, 1))
            ]),
        child: Stack(children: [
          Positioned(
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(500))),
              child: Center(
                child: Text(
                  '${trainPlanInForm.number}',
                  style: TextStyle(fontSize: 18, color: Colors.black87),
                ),
              ),
            ),
            left: 10,
            top: 10,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '编号：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${trainPlanInForm.code}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                  ),
                )
              ],
            ),
            top: 50,
            left: 10,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '名称：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.courseName}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 50,
            left: 180,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '开课单位：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.unit}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 90,
            left: 10,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '学分：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.credit}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 90,
            left: 180,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '学时：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.creditHour}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 130,
            left: 10,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '考核模式：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.evaMode}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 130,
            left: 180,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '课程属性：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.property}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 170,
            left: 10,
          ),
          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '是否考核：',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  '${trainPlanInForm.isExam}',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            top: 170,
            left: 180,
          )
        ]),
      ),
    );
  }
}
