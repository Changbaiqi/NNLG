import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'logic.dart';

class ScoreInquiryViewPage extends StatelessWidget {
  ScoreInquiryViewPage({Key? key}) : super(key: key);

  final logic = Get.find<ScoreInquiryViewLogic>();
  final state = Get.find<ScoreInquiryViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    var itemHeight = 255.0;
    var childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '成绩查询',
            ),
            Obx(() => DropdownButton<String>(
                value: state.selectTime.value,
                items: state.searList.value
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(e),
                        )))
                    .toList(),
                onChanged: (value) {
                  state.selectTime.value = value!;
                  logic.showScoreList(state.selectTime.value);
                  // state.mfuture = logic.future();
                }))
          ],
        ),
      ),
      // body: ListView(
      //   children: [_showScoreWidget],
      // ),
      body: Obx(() {
        switch (state.showState.value) {
          case 0:
            return Center(
                child: Lottie.asset('assets/images/loading.json',
                    height: 200, width: 200));
          case 1:
            return ListView(
              children: [
                /*_showScoreWidget,*/ Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: state.scoreList.length,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: Duration(milliseconds: 350),
                              columnCount: state.scoreList.length,
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child:
                                      showchildElement(state.scoreList[index]),
                                ),
                              ));
                        },
                      ),
                    ),
                    //_showchildElement("json")
                  ],
                )
              ],
            );
          default:
            return Center(
              child: Text('错误'),
            );
        }
      }),
    );
  }

  /**
   * 单个组件
   */
  showchildElement(json) {
    //print(json);
    int colorR = 0;
    int colorG = 0;
    int colorB = 0;
    while (true) {
      colorR = Random().nextInt(255);
      colorG = Random().nextInt(255);
      colorB = Random().nextInt(255);
      if ((colorR - colorG).abs() >= 40 || (colorG - colorB).abs() >= 40) break;
    }
    //print(json);
    json = jsonDecode(json);
    //var jsson = jsonDecode('{"name":"cc"}');
    return Container(
      height: 220,
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Color.fromARGB(255, colorR, colorG, colorB),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '编号：',
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
          top: 50,
          left: 10,
        ),
        Positioned(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '科目：',
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
          top: 90,
          left: 10,
        ),
        Positioned(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '时间：',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                width: 100,
                child: Text(
                  '${json["time"]}',
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
            children: [
              Text(
                '成绩：',
                style: TextStyle(fontSize: 15),
              ),
              Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: logic.scoreColors(json['courseScore'])),
                  child: Center(
                    child: Text(
                      '${json["courseScore"]}',
                      style: TextStyle(fontSize: 30),
                    ),
                  ))
            ],
          ),
          top: 140,
          left: 10,
        ),
      ]),
    );
  }
}
