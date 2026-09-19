/* FileName ClassScheduleWidget
 *
 * @Author 20840
 * @Date 2024/6/20 10:17
 *
 * @Description TODO 单个课表组件，用于渲染单个课表的显示的
 */

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/showCourseTableMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tencent_kit/tencent_kit.dart';

import '../../utils/CustomerThemeUtil.dart';
import '../../utils/CourseShareImageUtil.dart';
import '../../utils/GlassUI.dart';

class ClassScheduleWidget extends StatefulWidget {
  // const ClassScheduleWidget({super.key});
  final tableJson; //课程信息的json
  final isNoon;
  final isMin; //是否小节显示
  final isColor; //是否彩色显示
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
      "start": TimeOfDay(hour: 14, minute: 00),
      "end": TimeOfDay(hour: 14, minute: 45)
    },
    {
      "start": TimeOfDay(hour: 14, minute: 50),
      "end": TimeOfDay(hour: 15, minute: 35)
    },
    {
      "start": TimeOfDay(hour: 15, minute: 45),
      "end": TimeOfDay(hour: 16, minute: 30)
    },
    {
      "start": TimeOfDay(hour: 16, minute: 35),
      "end": TimeOfDay(hour: 17, minute: 20)
    },
    {
      "start": TimeOfDay(hour: 18, minute: 30),
      "end": TimeOfDay(hour: 19, minute: 15)
    },
    {
      "start": TimeOfDay(hour: 19, minute: 20),
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
  }

  @override
  State<ClassScheduleWidget> createState() => _ClassScheduleWidgetState(
      tableJson: tableJson,
      isNoon: isNoon,
      columTimeList: columTimeList,
      rowTimeList: rowTimeList,
      isMin: isMin,
      isColor: isColor);
}

class _ClassScheduleWidgetState extends State<ClassScheduleWidget>
    with SingleTickerProviderStateMixin {
  dynamic tableJson; //课程信息的json
  dynamic isNoon;
  final noonWidgetHeight = 23.0; //午休控件高度
  dynamic isMin; //是否小节显示
  dynamic isColor; //是否彩色显示
  final List<List<dynamic>> isOccupy = []; //用于标记哪些格子是用过的
  /// 动画类
  late Animation<double> animation;

  /// 动画控制器
  late AnimationController animationController;

  //同步新数据（修复同步课表后当前页不刷新的问题）
  @override
  void didUpdateWidget(covariant ClassScheduleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    tableJson = widget.tableJson;
    isNoon = widget.isNoon;
    isMin = widget.isMin;
    isColor = widget.isColor;
    rowTimeList = widget.rowTimeList;
    columTimeList = List<DateTime>.from(widget.columTimeList);
  }

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
  List<DateTime> columTimeList = [
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

  _ClassScheduleWidgetState({
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
    //用于构建标记格子数组（每次重建前清空，避免无限增长与脏标记）
    isOccupy.clear();
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
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                              color: _itemOpacity(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['leftTopShowColor'] as List)),
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Obx(() => Text(
                              '${isMin.value ? '小' : '大'}节\n显示',
                              style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                            )),
                          ),
                        ),
                      ),
                      onTap: () {
                        ShareDateUtil().setIsMinForSchedule(!isMin.value);
                      },
                    ),
                  ),
                  ...columTimeList.map((e) {
                    final bool isToday = DateTime.now().month == e.month &&
                        DateTime.now().day == e.day;
                    final Color todayBg = CustomerThemeUtil.setColor(
                        CustomThemeData.nowThemeData.value['main_course_view']!['todayCourseItemColor']['weekBackgroundColor'] as List);
                    final Color todayBorder = CustomerThemeUtil.setColor(
                        CustomThemeData.nowThemeData.value['main_course_view']!['todayCourseItemColor']['weekBorderColor'] as List);
                    final Color normalBg = CustomerThemeUtil.setColor(
                        CustomThemeData.nowThemeData.value['main_course_view']!['nonTodayCourseItemColor']['weekBackgroundColor'] as List);
                    final Color normalBorder = CustomerThemeUtil.setColor(
                        CustomThemeData.nowThemeData.value['main_course_view']!['nonTodayCourseItemColor']['weekBorderColor'] as List);
                    return Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                            color: isToday ? null : _itemOpacity(normalBg),
                            gradient: isToday
                                ? LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      _itemOpacity(todayBg),
                                      _itemOpacity(todayBg).withValues(
                                          alpha: _itemOpacity(todayBg).a *
                                              0.55)
                                    ],
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(8),
                            border:
                                Border.all(color: isToday ? todayBorder : normalBorder)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '周${weekToChar[e.weekday - 1]}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.w400,
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                            ),
                            Text(
                              '${e.month}/${e.day}',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                            )
                          ],
                        ),
                      ),
                    ));
                  }).toList()
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
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: _tablePanelColor,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                  color: _tableBorderColor, width: 1),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18),
                              child: Stack(
                            children: [
                              _backgroundLine(
                                  noonSwitch: isNoon.value,
                                  isMin: isMin.value),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                child: _timeBackground(
                                    noonSwitch: isNoon.value,
                                    isMin: isMin.value),
                                onTap: () {
                                  ShareDateUtil()
                                      .setIsMinForSchedule(!isMin.value);
                                  // columTimeList.reactive;

                                },
                                onLongPress: () async {
                                  await capturePngFilePath(
                                      _weekViewKey, _tableViewKey);
                                },
                              ),
                              drawTable(tableJson),
                            ],
                              ),
                            ),
                          ),
                        )),
                      )
                    ],
                  )),
              flex: 1,
            )
          ],
        )
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
  Future<String?> capturePngFilePath(weekKey, tableKey) async {
    try {
      final RenderRepaintBoundary? headerBoundary =
          weekKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final RenderRepaintBoundary? tableBoundary =
          tableKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (headerBoundary == null || tableBoundary == null) return null;
      Get.snackbar('课表通知', '正在生成课表图片...',
          duration: const Duration(milliseconds: 1200));
      //完整表格 + 背景图合成（背景图不在截图区域内，表格比可视区域高）
      final Uint8List? picBytes =
          await CourseShareImageUtil.captureWeekWithBackground(
        headerBoundary: headerBoundary,
        tableBoundary: tableBoundary,
      );
      if (picBytes == null) return null;
      final String path = await CourseShareImageUtil.writeTempPng(picBytes);
      await Share.shareXFiles([XFile(path)], text: '南理校园助手');
      return path;
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
        var result = await [Permission.photos].request();
        status = result[Permission.photos] ?? status;
      }
      return status.isGranted;
    } else {
      //Android 10 及以上通过 MediaStore 保存，无需存储权限，直接放行避免死循环
      var status = await Permission.storage.status;
      if (status.isGranted) return true;
      if (status.isDenied) {
        var result = await [Permission.storage].request();
        status = result[Permission.storage] ?? status;
      }
      return true;
    }
  }

  //保存到相册
  void savePhoto() async {
    try {
      final RenderRepaintBoundary? headerBoundary = _weekViewKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      final RenderRepaintBoundary? tableBoundary = _tableViewKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;
      if (headerBoundary == null || tableBoundary == null) return;

      //完整表格 + 背景图合成（背景图不在截图区域内，表格比可视区域高）
      final Uint8List? captured =
          await CourseShareImageUtil.captureWeekWithBackground(
        headerBoundary: headerBoundary,
        tableBoundary: tableBoundary,
      );
      if (captured == null) return;
      //获取保存相册权限，如果没有，则申请该权限
      bool permition = await getPormiation();
      if (!permition) return; //权限被拒绝时直接返回，避免无限递归
      var status = await Permission.photos.status;
      if (Platform.isIOS) {
        if (status.isGranted) {
          Uint8List images = captured;
          final result = await ImageGallerySaverPlus.saveImage(images,
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
        //安卓：getPormiation 已放行，直接保存（Android 10+ 走 MediaStore）
        Uint8List images = captured;
        final result = await ImageGallerySaverPlus.saveImage(images,
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
    } catch (e) {
      print(e);
    }
  }

  //动画进度（由 animationController 驱动）
  final _animTick = 0.0.obs;

  /// 表格网格线颜色：统一跟随主题（深色主题下不再用纯黑导致看不见）
  /// 课表项/表头控件的背景透明度（设置里的「课表项透明度」）
  Color _itemOpacity(Color color) {
    final double opacity = CourseData.courseItemOpacity.value.clamp(0.0, 1.0);
    return color.withValues(alpha: color.a * opacity);
  }

  /// 彩色课表的课程块颜色：
  /// 以当前主题主色为基调，按课程名哈希在 ±60° 内偏移色相，
  /// 并按深浅色选择明度/饱和度，保证与所选配色协调且文字清晰
  Color _courseBlockColor(String title) {
    final ColorScheme scheme = GlassTheme.scheme;
    final bool dark = CustomThemeData.isDarkTheme;
    final double baseHue =
        HSLColor.fromColor(scheme.primary).hue.clamp(0, 360).toDouble();
    final double offset = ((title.hashCode % 120) - 60).toDouble();
    final double hue = (baseHue + offset + 360) % 360;
    return HSLColor.fromAHSL(
      1,
      hue,
      dark ? .34 : .46,
      dark ? .30 : .86,
    ).toColor();
  }

  Color get _lineColor => GlassTheme.color('main_course_view', 'courseLineColor',
      const Color(0xFF9E9E9E)).withValues(alpha: .85);

  /// 课表面板底色/描边（轻微玻璃感，不影响自定义背景图）
  Color get _tablePanelColor => GlassTheme.pageBackground('main_course_view')
      .withValues(alpha: GlassTheme.isDark('main_course_view') ? .10 : .16);

  Color get _tableBorderColor =>
      GlassTheme.border('main_course_view').withValues(alpha: .55);

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
      //彩色课表的课程色：跟随主题配色（主色基调 + 课程名色相偏移 + 明暗适配）
      var color = _courseBlockColor('${element["title"]}');
      final int order = list.length;
      list.add(Positioned(
        child: Obx(() {
          final double t = _animTick.value;
          //错峰入场：淡入 + 轻微上移
          final double stagger =
              ((t * 1.8) - order * 0.05).clamp(0.0, 1.0).toDouble();
          final double eased = Curves.easeOutCubic.transform(stagger);
          return Transform.translate(
          offset: Offset(0, (1 - eased) * 14),
          child: Opacity(
            opacity: 0.15 + 0.85 * eased,
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
                          ? _itemOpacity(color)
                          : ((columTimeList[element['columStart'] - 1].month ==
                          DateTime.now().month) &&
                          (columTimeList[element['columStart'] - 1]
                              .day ==
                              DateTime.now().day)?_itemOpacity(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['todayCourseItemColor']['backgroundColor'] as List )):_itemOpacity(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['nonTodayCourseItemColor']['backgroundColor'] as List ))),
                      //设置四周边框
                      border: (columTimeList[element['columStart'] - 1].month ==
                          DateTime.now().month) &&
                          (columTimeList[element['columStart'] - 1]
                              .day ==
                              DateTime.now().day)? Border.all(
                          width: 1, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['todayCourseItemColor']['borderColor']as List )):Border.all(width: 1,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['nonTodayCourseItemColor']['borderColor']as List )),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: '${element["title"]}',
                        children: element['data'].length == 1
                            ? [
                                TextSpan(
                                  text:
                                      '\n${element['data'][0]['courseClassRoom']}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: GlassTheme.scheme.tertiary,
                                  ),
                                )
                              ]
                            : [],
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.15,
                          fontWeight: FontWeight.w600,
                          // color: Color.fromARGB(
                          //     element['style']['textColor'][0],
                          //     element['style']['textColor'][1],
                          //     element['style']['textColor'][2],
                          //     element['style']['textColor'][3])
                          color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                        ),
                      ),
                      maxLines: 9,
                      overflow: TextOverflow.ellipsis,
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
                    (columTimeList[element["columStart"] - 1] as DateTime)
                        .month,
                    (columTimeList[element["columStart"] - 1] as DateTime).day,
                  ),
                );
              },
            ),
          ),
        );
        }),
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
                left: BorderSide(width: 0.05, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                right: BorderSide(width: 0.05, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
              )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
              border: Border.all(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List ), width: 0.05)),
          child: Center(
            child: Text("午休",style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),),
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
                left: BorderSide(width: 0.05, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                right: BorderSide(width: 0.05, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
              )),
              child: Visibility(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                left: BorderSide(width: 0.05, color: _lineColor),
                right: BorderSide(width: 0.05, color: _lineColor),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][x]["state"] &&
                            isOccupy[y][x]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['courseLineColor'] as List )),
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
                left: BorderSide(width: 0.05, color: _lineColor),
                right: BorderSide(width: 0.05, color: _lineColor),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                left: BorderSide(width: 0.05, color: _lineColor),
                right: BorderSide(width: 0.05, color: _lineColor),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                  left: BorderSide(width: 0.05, color: _lineColor),
                  right: BorderSide(width: 0.05, color: _lineColor),
                  top: BorderSide(
                      width: 0.05,
                      color: (isOccupy[y][0]["state"] &&
                              isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                          ? Colors.transparent
                          : _lineColor),
                  bottom: BorderSide(
                      width: 0.05,
                      color: (isOccupy[y][0]["state"] &&
                              isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                          ? Colors.transparent
                          : _lineColor),
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                left: BorderSide(width: 0.05, color: _lineColor),
                right: BorderSide(width: 0.05, color: _lineColor),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                left: BorderSide(width: 0.05, color: _lineColor),
                right: BorderSide(width: 0.05, color: _lineColor),
                top: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
                bottom: BorderSide(
                    width: 0.05,
                    color: (isOccupy[y][0]["state"] &&
                            isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                        ? Colors.transparent
                        : _lineColor),
              )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${y + 1}',
                    style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["start"].hour, rowTimeList[y]["start"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '至',
                    style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                  ),
                  Text(
                    '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y]["end"].hour, rowTimeList[y]["end"].minute), [
                          HH,
                          ":",
                          nn
                        ])}',
                    style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                  left: BorderSide(width: 0.05, color: _lineColor),
                  right: BorderSide(width: 0.05, color: _lineColor),
                  top: BorderSide(
                      width: 0.05,
                      color: (isOccupy[y][0]["state"] &&
                              isOccupy[y][0]["table"]["rowStart"] - 1 != y)
                          ? Colors.transparent
                          : _lineColor),
                  bottom: BorderSide(
                      width: 0.05,
                      color: (isOccupy[y][0]["state"] &&
                              isOccupy[y][0]["table"]["rowEnd"] - 1 != y)
                          ? Colors.transparent
                          : _lineColor),
                )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${y + 1}',
                      style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2]["start"].hour, rowTimeList[y * 2]["start"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '至',
                      style: TextStyle(fontSize: 9,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                    ),
                    Text(
                      '${formatDate(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, rowTimeList[y * 2 + 1]["end"].hour, rowTimeList[y * 2 + 1]["end"].minute), [
                            HH,
                            ":",
                            nn
                          ])}',
                      style: TextStyle(fontSize: 10,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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

  @override
  void initState() {
    super.initState();

    /// 1. 初始化动画控制器
    animationController = AnimationController(
      // 动画绘制到屏幕外部时, 减少消耗
      vsync: this,
      // 动画持续时间 2 秒
      duration: Duration(milliseconds: 500),
    );

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.linear)
          ..addListener(() {
            _animTick.value = animationController.value;
          });
    animationController.forward();
  }

  /// 该方法与 initState 对应
  @override
  void dispose() {
    /// 释放动画控制器
    animationController.dispose();
    super.dispose();
  }
}
