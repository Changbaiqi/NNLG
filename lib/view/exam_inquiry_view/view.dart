import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:sqflite/utils/utils.dart';

import 'logic.dart';

class ExamInquiryViewPage extends StatelessWidget {
  ExamInquiryViewPage({Key? key}) : super(key: key);

  final logic = Get.find<ExamInquiryViewLogic>();
  final state = Get.find<ExamInquiryViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    var itemHeight = 255.0;
    var childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('考试安排'),
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
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Obx((){
        switch(state.showState.value){
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
                          return showchildElement(state.scoreList[index]);
                        },
                      ),
                    ),
                    //_showchildElement("json")
                  ],
                )
              ],
            );
          default:
            return Center(child: Text('错误'),);
        }
      }),
    );
  }


  /**
   * 单个组件
   */
  showchildElement(json){
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

    Options options =Options(format: Format.rgbArray,count: 1,luminosity: Luminosity.light);
    var color = RandomColor.getColor(options);
    // print(color);

    // log(color);    //print(json);
    json = jsonDecode(json);
    //var jsson = jsonDecode('{"name":"cc"}');
    return Container(
      height: 220,
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          // color: Color.fromARGB(255, colorR, colorG, colorB),
        color: Color.fromARGB(255, color[0], color[1], color[2]),
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(1, 1)
            )
          ]
      ),
      child: Stack(
          children: [
            Positioned(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(500))
                  ),
                  child: Center(
                    child: Text('${json["number"]}',style: TextStyle(fontSize: 18,color: Colors.black87),),
                  ),
                ),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('科目：',style: TextStyle(fontSize: 15),),
                    Container(
                      width: Get.width/4.5,
                      child: Text('${json["courseName"]}',style: TextStyle(fontSize: 12),maxLines: 3,),
                    )
                  ],
                ),),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('时间：',style: TextStyle(fontSize: 15),),
                    Container(
                      width: Get.width/4.5,
                      child: Text('${json["examTime"].toString().replaceAll(" ", "\n")}',style: TextStyle(fontSize: 12),maxLines: 3,),
                    )
                  ],
                )),
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('考场：',style: TextStyle(fontSize: 15),),
                    Container(
                        width: Get.width/4.5,
                        child: Text('${json["examRoom"]}',style: TextStyle(fontSize: 12,),maxLines: 3,)
                    )
                  ],
                ),),
              Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Row(
                  children: [
                    Text('座位号：',style: TextStyle(fontSize: 15),),
                    Text('${json["seatNumber"]}',style: TextStyle(fontSize: 12),)
                  ],
                ))
              ],
            ),top: 10,left: 10,),
            // Positioned(child: ,top: 90,left: 10,),

          ]
      ),
    );
  }
}
