import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class EvaDetailViewPage extends StatelessWidget {
  EvaDetailViewPage({Key? key}) : super(key: key);

  final logic = Get.find<EvaDetailViewLogic>();
  final state = Get.find<EvaDetailViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    // var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    // var itemHeight = 255.0;
    // var childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '在线评教',
            )
          ],
        ),
      ),
      // body: ListView(
      //   children: [_showScoreWidget],
      // ),
      body: Obx((){
        switch(state.showState.value){
          case 0:
            return Center(
                child: Lottie.asset('assets/images/loading.json',
                    height: 200, width: 200));
          case 1:
            return ListView.builder(
                itemCount: state.searList.value.length,
                itemBuilder: (cont,index)=>showchildElement(state.searList.value[index]));
          default:
            return Center(child: Text('错误'),);
        }
      }),
    );
  }

  /**
   * 单个组件
   */
  showchildElement(json) {
    Options options =Options(format: Format.rgbArray,count: 1,luminosity: Luminosity.light);
    var color = RandomColor.getColor(options);
    //print(json);
    //var jsson = jsonDecode('{"name":"cc"}');
    return Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
      child: InkWell(
        child: Container(
          height: 150,
          width: 150,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, color[0], color[1], color[2]),
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
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(500))),
                child: Center(
                  child: Text(
                    '${json["number"]}',
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '课程名称：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["courseName"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 10,
              left: 50,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '课程编号：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["courseNumber"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 45,
              left: 10,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '授课教师：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["teacher"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 45,
              left: 185,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '评教类别：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["evalType"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 70,
              left: 10,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '总评分：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["overallScore"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 70,
              left: 185,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '是否已评：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["isRated"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 95,
              left: 10,
            ),
            Positioned(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '是否提交：',
                    style: TextStyle(fontSize: 15),
                  ),
                  Container(
                    width: 100,
                    child: Text(
                      '${json["isSubmit"]}',
                      style: TextStyle(fontSize: 12),
                      maxLines: 2,
                    ),
                  )
                ],
              ),
              top: 95,
              left: 185,
            ),
          ]),
        ),
        onTap: (){

          Get.toNamed(Routes.EvalForm,arguments: json);
          // Get.snackbar("提示", "功能还未完善，敬请期待",duration: Duration(milliseconds: 1500),);
        },
      ),);
  }
}
