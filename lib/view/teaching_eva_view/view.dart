import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class TeachingEvaViewPage extends StatelessWidget {
  TeachingEvaViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TeachingEvaViewLogic>();
  final state = Get.find<TeachingEvaViewLogic>().state;

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
    // int colorR = 0;
    // int colorG = 0;
    // int colorB = 0;
    // while (true) {
    //   colorR = Random().nextInt(255);
    //   colorG = Random().nextInt(255);
    //   colorB = Random().nextInt(255);
    //   if ((colorR - colorG).abs() >= 40 || (colorG - colorB).abs() >= 40) break;
    // }
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
            // color: Color.fromARGB(255, colorR, colorG, colorB),
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
                  '学年学期：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${json["schoolYear"]}',
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
                  '评价分类：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${json["evalClass"]}',
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
                  '评价批次：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${json["evalBatch"]}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                  ),
                )
              ],
            ),
            top: 45,
            left: 170,
          ),
          Positioned(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '开始时间：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${json["evalStartTime"]}',
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
                  '结束时间：',
                  style: TextStyle(fontSize: 15),
                ),
                Container(
                  width: 100,
                  child: Text(
                    '${json["evalEndTime"]}',
                    style: TextStyle(fontSize: 12),
                    maxLines: 2,
                  ),
                )
              ],
            ),
            top: 70,
            left: 170,
          ),
        ]),
      ),
      onTap: (){
        Get.toNamed(Routes.TeachingEvaDetails,arguments: {'url':json['evalUrl']});
      },
    ),);
  }
}
