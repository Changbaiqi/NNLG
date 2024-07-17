/* FileName ClassScheduleWidget
 *
 * @Author 20840
 * @Date 2024/6/20 10:17
 *
 * @Description TODO 单个课表组件，用于渲染单个课表的显示的
 */

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/module/showCourseTableMessage.dart';

class ClassScheduleWidget extends StatelessWidget {
  final tableJson; //课程信息的json
  final isNoon;
  final noonWidgetHeight = 23.0; //午休控件高度
  final isMin; //是否小节显示
  final List<List<dynamic>> isOccupy = []; //用于标记哪些格子是用过的
  //默认课表时间
  List<dynamic> rowTimeList = [
    {
      "start": TimeOfDay(hour: 8, minute: 30),
      "end": TimeOfDay(hour: 9, minute: 15)
    },
    {
      "start": TimeOfDay(hour: 9, minute: 20),
      "end": TimeOfDay(hour: 10, minute: 5)
    },
    {
      "start": TimeOfDay(hour: 10, minute: 25),
      "end": TimeOfDay(hour: 11, minute: 10)
    },
    {
      "start": TimeOfDay(hour: 11, minute: 15),
      "end": TimeOfDay(hour: 12, minute: 00)
    },
    {
      "start": TimeOfDay(hour: 14, minute: 30),
      "end": TimeOfDay(hour: 15, minute: 15)
    },
    {
      "start": TimeOfDay(hour: 15, minute: 20),
      "end": TimeOfDay(hour: 16, minute: 05)
    },
    {
      "start": TimeOfDay(hour: 16, minute: 15),
      "end": TimeOfDay(hour: 17, minute: 00)
    },
    {
      "start": TimeOfDay(hour: 17, minute: 05),
      "end": TimeOfDay(hour: 17, minute: 50)
    },
    {
      "start": TimeOfDay(hour: 18, minute: 20),
      "end": TimeOfDay(hour: 19, minute: 05)
    },
    {
      "start": TimeOfDay(hour: 19, minute: 10),
      "end": TimeOfDay(hour: 19, minute: 55)
    },
    {
      "start": TimeOfDay(hour: 20, minute: 05),
      "end": TimeOfDay(hour: 20, minute: 50)
    },
    {
      "start": TimeOfDay(hour: 20, minute: 55),
      "end": TimeOfDay(hour: 21, minute: 40)
    }
  ];
  final List<String> weekToChar = ["一", "二", "三", "四", "五", "六", "日"];

  //默认列时间
  List<dynamic> columTimeList = [
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now(),
    DateTime.now()
  ];

  // static final _weekViewKey = GlobalKey();

  ClassScheduleWidget(
      {this.tableJson,
      this.isNoon = false,
      columTimeList,
      rowTimeList,
      required this.isMin}) {
    if (columTimeList != null) this.columTimeList = columTimeList;
    if (rowTimeList != null) this.rowTimeList = rowTimeList;
    // if(isMin!=null) this.isMin.value = isMin;
  }

  @override
  Widget build(BuildContext context) {
    //用于构建标记格子数组
    for (int i = 0; i < 12; ++i)
      isOccupy.add([
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}},
        {"state": false, "table": {}}
      ]);

    return Column(
      children: [
        Container(
          // key: _weekViewKey,
          height: 50,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: InkWell(
                    child: Container(
                      child: Obx(() => Text(
                            '${isMin.value ? '小' : '大'}节\n显示',
                            style: TextStyle(fontSize: 10),
                          )),
                    ),
                    onTap: () {
                      isMin.value = !isMin.value;
                      isMin.refresh();
                    },
                  ),
                ),
              )),
              ...columTimeList
                  .map((e) => Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: DateTime.now().month == e.month &&
                                    DateTime.now().day == e.day
                                ? Color.fromARGB(30, 59, 52, 86)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: DateTime.now().month == e.month &&
                                    DateTime.now().day == e.day
                                ? Border.all(
                                    color: Color.fromARGB(130, 59, 52, 86))
                                : Border.all(color: Colors.transparent)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('周${weekToChar[e.weekday - 1]}'),
                            Text('${e.month}/${e.day}')
                          ],
                        ),
                      )))
                  .toList()
            ],
          ),
        ),
        Expanded(
          child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Container(
                    // decoration: BoxDecoration(color: Colors.amber),
                    height: 1000,
                    child: Stack(
                      children: [
                        Obx(() => _backgroundLine(noonSwitch: isNoon,isMin: isMin.value)),
                        drawTable(tableJson),
                      ],
                    ),
                  )
                ],
              )),
          flex: 1,
        )
      ],
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 绘制表格
   * [date] 23:22 2024/7/14
   * [param] null
   * [return]
   */
  Widget drawTable(tableJson) {
    // if(tableJson==null) return Stack();
    // log(jsonEncode(tableJson));
    if (tableJson["tables"] == null) return Stack();
    List<Widget> list = [];
    List tables = tableJson["tables"];
    // log(courses.toString());
    for (int i = 0; i < tables.length; ++i) {
      var element = tables[i];
      list.add(Positioned(
        child: InkWell(
          child: Container(
            height: 70.0 * (element["rowEnd"] - element["rowStart"] + 1),
            width: Get.context!.width /
                8 *
                (element["columEnd"] - element["columStart"] + 1),
            child: Padding(
              padding: EdgeInsets.all(2.5),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.fromARGB(
                      (columTimeList[element['columStart'] - 1].month ==
                                  DateTime.now().month) &&
                              (columTimeList[element['columStart'] - 1].day ==
                                  DateTime.now().day)
                          ? 130
                          : 30,
                      59,
                      52,
                      86),
                  //设置四周边框
                  border: new Border.all(
                      width: 1, color: Color.fromARGB(80, 59, 52, 86)),
                ),
                child: Text(
                  element["title"],
                  style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(
                          element['style']['textColor'][0],
                          element['style']['textColor'][1],
                          element['style']['textColor'][2],
                          element['style']['textColor'][3])),
                ),
              ),
            ),
          ),
          onTap: () {
            // log(element.toString());
            showCourseTableMessage(Get.context!).show(
              element['data'],
              DateTime(
                (columTimeList[element["columStart"] - 1] as DateTime).year,
                (columTimeList[element["columStart"] - 1] as DateTime).month,
                (columTimeList[element["columStart"] - 1] as DateTime).day,
              ),
            );
          },
        ),
        left: Get.context!.width / 8 * element["columStart"],
        top: 70.0 * (element["rowStart"] - 1) +
            (isNoon && element["rowStart"] >= 5 ? noonWidgetHeight : 0),
      ));
    }
    return Stack(
      children: list,
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 课表背景线绘制
   * [date] 23:18 2024/7/14
   * [param] null
   * [return]
   */
  Widget _backgroundLine({bool noonSwitch = false,bool isMin=true}) {
    //根据tableJson导入标记格子
    if (tableJson["tables"] != null) {
      List tables = tableJson["tables"];
      tables.forEach((element) {
        for (int x = element["columStart"]; x <= element["columEnd"]; ++x) {
          for (int y = element["rowStart"] - 1; y < element["rowEnd"]; ++y) {
            isOccupy[y][x]["state"] = true;
            isOccupy[y][x]["table"] = element;
          }
        }
      });
    }
    //渲染背景线
    List<Widget> list = [];
    if (noonSwitch) {

      //左侧时间轴渲染
      if(isMin){//如果小节显示
        for (int y = 0; y < 4; ++y) {
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 0.05, color: Colors.black),
                    right: BorderSide(width: 0.05, color: Colors.black),
                    top: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                    bottom: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                  )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[y]["end"].hour}:${rowTimeList[y]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: 0 == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * y,
          ));
        }
      }else{
        for (int y = 0; y < 2; ++y) {
          list.add(Positioned(
            child: Container(
              height: 140,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 0.05, color: Colors.black),
                    right: BorderSide(width: 0.05, color: Colors.black),
                    top: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                    bottom: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                  )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[(y*2)+1]["end"].hour}:${rowTimeList[(y*2)+1]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: 0 == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * (y*2),
          ));
        }
      }

      //表格线段渲染
      for (int x = 1; x < 8; ++x) {
        for (int y = 0; y < 4; ++y) {
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 0.05, color: Colors.black),
                right: BorderSide(width: 0.05, color: Colors.black),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
              )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[y]["end"].hour}:${rowTimeList[y]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: x == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * x,
            top: 70.0 * y,
          ));
        }
      }
      list.add(Positioned(
        child: Container(
          height: noonWidgetHeight,
          width: Get.context!.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.05)),
          child: Center(
            child: Text("午休"),
          ),
        ),
        left: 0,
        top: 70.0 * 4,
      ));


      if(isMin){//如果小节显示
        for (int y = 4; y < 12; ++y) {
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 0.05, color: Colors.black),
                    right: BorderSide(width: 0.05, color: Colors.black),
                    top: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                    bottom: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                  )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[y]["end"].hour}:${rowTimeList[y]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: 0 == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * y+noonWidgetHeight,
          ));
        }
      }else{
        for (int y = 2; y < 6; ++y) {
          list.add(Positioned(
            child: Container(
              height: 140,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 0.05, color: Colors.black),
                    right: BorderSide(width: 0.05, color: Colors.black),
                    top: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                    bottom: BorderSide(
                        width: 0.05,
                        color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                            ? Colors.transparent
                            : Colors.black),
                  )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[(y*2)+1]["end"].hour}:${rowTimeList[(y*2)+1]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: 0 == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * (y*2)+noonWidgetHeight,
          ));
        }
      }

      for (int x = 1; x < 8; ++x) {
        for (int y = 4; y < 12; ++y) {
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 0.05, color: Colors.black),
                right: BorderSide(width: 0.05, color: Colors.black),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
              )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[y]["end"].hour}:${rowTimeList[y]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: x == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * x,
            top: 70.0 * y + noonWidgetHeight,
          ));
        }
      }
    } else {
      for (int x = 0; x < 8; ++x) {
        for (int y = 0; y < 12; ++y) {
          //添加左侧时间
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 0.05, color: Colors.black),
                right: BorderSide(width: 0.05, color: Colors.black),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
              )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${rowTimeList[y]["start"].hour}:${rowTimeList[y]["start"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${rowTimeList[y]["end"].hour}:${rowTimeList[y]["end"].minute}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ),
                visible: x == 0 ? true : false,
              ),
            ),
            left: Get.context!.width / 8 * x,
            top: 70.0 * y,
          ));

          //添加表格
          list.add(Positioned(
            child: Container(
              height: 70,
              width: Get.context!.width / 8,
              decoration: BoxDecoration(
                  border: Border(
                left: BorderSide(width: 0.05, color: Colors.black),
                right: BorderSide(width: 0.05, color: Colors.black),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : Colors.black),
              )),
            ),
            left: Get.context!.width / 8 * x,
            top: 70.0 * y,
          ));
        }
      }
    }

    return Stack(
      children: list,
    );
  }
}
