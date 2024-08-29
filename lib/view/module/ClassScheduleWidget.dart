/* FileName ClassScheduleWidget
 *
 * @Author 20840
 * @Date 2024/6/20 10:17
 *
 * @Description TODO 单个课表组件，用于渲染单个课表的显示的
 */

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/view/module/showCourseTableMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tencent_kit/tencent_kit.dart';

class ClassScheduleWidget extends StatelessWidget {
  final tableJson; //课程信息的json
  final isNoon;
  final noonWidgetHeight = 23.0; //午休控件高度
  final isMin; //是否小节显示
  final isColor; //是否彩色显示
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

  final _weekViewKey = GlobalKey();
  final _tableViewKey = GlobalKey();
  ClassScheduleWidget({
    this.tableJson,
    required this.isNoon,
    columTimeList,
    rowTimeList,
    required this.isMin,
    this.isColor,
  }) {
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

    return RepaintBoundary(
      key: _weekViewKey,
      child: Column(
        children: [
          Container(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Obx(() => Text(
                            '${isMin.value ? '小' : '大'}节\n显示',
                            style: TextStyle(fontSize: 10),
                          )),
                        ),
                      ),
                    ),
                    onTap: () {
                      ShareDateUtil().setIsMinForSchedule(!isMin.value);
                    },
                  ),
                ),
                ...columTimeList
                    .map((e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(4),
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
                            Text(
                              '周${weekToChar[e.weekday - 1]}',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              '${e.month}/${e.day}',
                              style: TextStyle(fontSize: 12),
                            )
                          ],
                        ),
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
                  shrinkWrap: true,
                  children: [
                    Container(
                      // decoration: BoxDecoration(color: Colors.amber),
                      height: 900,
                      child: Obx(() => RepaintBoundary(
                        key: _tableViewKey,
                        child: Stack(
                          children: [
                            _backgroundLine(
                                noonSwitch: isNoon.value, isMin: isMin.value),
                            InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              child: _timeBackground(
                                  noonSwitch: isNoon.value, isMin: isMin.value),
                              onTap: () {
                                ShareDateUtil()
                                    .setIsMinForSchedule(!isMin.value);
                              },
                              onLongPress: () async {
                                // await capturePngFilePath(_tableViewKey,_weekViewKey);
                                await capturePngFilePath(_weekViewKey,_weekViewKey);
                              },
                            ),
                            drawTable(tableJson),
                          ],
                        ),
                      )),
                    )
                  ],
                )),
            flex: 1,
          )
        ],
      ),
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 课表图片分享
   * [date] 13:24 2024/3/22
   * [param] null
   * [return]
   */
  Future<String?> capturePngFilePath(weekKey,tableKey) async {
    // TencentKitPlatform.instance.shareText(
    //   scene: TencentScene.kScene_QQ,
    //   summary: '分享测试',
    // );
    try {
      RenderRepaintBoundary weekBoundary =
      weekKey.currentContext.findRenderObject();
      RenderRepaintBoundary boundary =
          tableKey.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比

      ui.Image weekImage = await weekBoundary.toImage(pixelRatio: dpr);
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
      weekImage.height+image.height;

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List picBytes = byteData!.buffer.asUint8List();

      var tempDir = await getTemporaryDirectory();
      // 判断路径是否存在
      bool isDirExist = await Directory(tempDir.path).exists();
      if (!isDirExist) Directory(tempDir.path).create();
      var file =
          await File(tempDir.path + "${DateTime.now().toIso8601String()}.png")
              .writeAsBytes(picBytes);
      await Share.shareXFiles([XFile(file.path)], text: '南理校园助手');
      return file.path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  //申请存本地相册权限
  Future<bool> getPormiation() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
        ].request();
        // saveImage(globalKey);
      }
      return status.isGranted;
    } else {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
        ].request();
      }
      return status.isGranted;
    }
  }

  //保存到相册
  void savePhoto() async {
    RenderRepaintBoundary? boundary = _weekViewKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary?;

    double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
    var image = await boundary!.toImage(pixelRatio: dpr);
    // 将image转化成byte
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //获取保存相册权限，如果没有，则申请改权限
    bool permition = await getPormiation();

    var status = await Permission.photos.status;
    if (permition) {
      if (Platform.isIOS) {
        if (status.isGranted) {
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images,
              quality: 60, name: "hello");
          File saveFile = new File(result.replaceAll("file://", ""));
          await TencentKitPlatform.instance.shareImage(
              scene: TencentScene.kScene_QQ, imageUri: Uri.file(saveFile.path));
          // EasyLoading.showToast("保存成功");
        }
        if (status.isDenied) {
          print("IOS拒绝");
        }
      } else {
        //安卓
        if (status.isGranted) {
          print("Android已授权");
          Uint8List images = byteData!.buffer.asUint8List();
          final result = await ImageGallerySaver.saveImage(images,
              quality: 60, isReturnImagePathOfIOS: true);
          // print(result);
          if (result != null) {
            print(result['filePath']);
            // EasyLoading.showToast("保存成功");
            File saveFile =
                new File(result['filePath'].replaceAll("content://", ""));
            await Share.shareXFiles([XFile(saveFile.path + ".jpg")],
                text: '南理校园助手');
          } else {
            print('error');
            // toast("保存失败");
          }
        }
      }
    } else {
      //重新请求--第一次请求权限时，保存方法不会走，需要重新调一次
      savePhoto();
    }
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
      var hash = element["title"].hashCode;
      var hexColor = hash.toRadixString(16).substring(
          0,
          hash.toRadixString(16).length < 6
              ? hash.toRadixString(16).length
              : 6);
      var colorInt = int.parse(hexColor, radix: 16);
      // 提取ARGB分量
      var alpha = (colorInt >> 24) & 0xFF;
      var red = (colorInt >> 16) & 0xFF;
      var green = (colorInt >> 8) & 0xFF;
      var blue = colorInt & 0xFF;
      // 创建Color对象
      var color = Color.fromARGB(60, red, green, blue);
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
                  color: isColor.value
                      ? color
                      : Color.fromARGB(
                          (columTimeList[element['columStart'] - 1].month ==
                                      DateTime.now().month) &&
                                  (columTimeList[element['columStart'] - 1]
                                          .day ==
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
            var res = element['data'];
            var nowDate = DateTime.now();
            for (int i = 0; i < res.length; ++i) {
              res[i]['courseTime'] =
                  "${formatDate(DateTime(nowDate.year, nowDate.month, nowDate.day, rowTimeList[element["rowStart"] - 1]['start'].hour, rowTimeList[element["rowStart"] - 1]['start'].minute), [
                    HH,
                    ":",
                    nn
                  ])}-${formatDate(DateTime(nowDate.year, nowDate.month, nowDate.day, rowTimeList[element["rowEnd"] - 1]['end'].hour, rowTimeList[element["rowEnd"] - 1]['end'].minute), [
                    HH,
                    ":",
                    nn
                  ])}";
            }
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
            (isNoon.value && element["rowStart"] >= 5 ? noonWidgetHeight : 0),
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
  Widget _backgroundLine({bool noonSwitch = false, bool isMin = true}) {
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
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
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
      //添加午休分割线
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
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
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

  Widget _timeBackground({bool noonSwitch = false, bool isMin = true}) {
    List<Widget> list = [];
    //左侧时间轴渲染
    if (noonSwitch) {
      if (isMin) {
        //如果小节显示
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * y,
          ));
        }
        //如果小节显示
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * y + noonWidgetHeight,
          ));
        }
      } else {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * (y * 2),
          ));
        }
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * (y * 2) + noonWidgetHeight,
          ));
        }
      }
    } else {
      if (isMin) {
        for (int y = 0; y < 12; ++y) {
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * y,
          ));
        }
      } else {
        for (int y = 0; y < 6; ++y) {
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                )),
            left: Get.context!.width / 8 * 0,
            top: 70.0 * (y * 2),
          ));
        }
      }
    }

    return Stack(
      children: list,
    );
  }
}
