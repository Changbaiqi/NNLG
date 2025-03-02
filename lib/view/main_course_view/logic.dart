import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:date_format/date_format.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/ClassNewScheduleDao.dart';
import 'package:callo/dao/ClassScheduleDao.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/WeekDayForm.dart';
import 'package:callo/dao/entity/ClassNewScheduleEntity.dart';
import 'package:callo/dao/entity/ClassScheduleEntity.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/view/module/ClassScheduleWidget.dart';
import 'package:callo/view/module/showCourseTableMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:tencent_kit/tencent_kit.dart';
import 'package:uuid/uuid.dart';

import '../../dao/CustomThemeData.dart';
import 'state.dart';

class MainCourseViewLogic extends GetxController
    with SingleGetTickerProviderMixin {
  final MainCourseViewState state = MainCourseViewState();
  BuildContext? context;
  BuildContext? showCaseContext;
  final _isMin = true.obs; //是否为小节显示
  final remark = "".obs; // 课表备注显示内容
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final courseWidgetKey = GlobalKey(); //课表key

  AnimationController? animationController = null;

  Widget loading = Center(
    child: Text(
      'Loading...',
      style: TextStyle(fontSize: 10),
    ),
  );

  final pageController = PageController(
    initialPage: CourseData.nowWeek.value - 1,
  ).obs;


  GlobalKey showCase_1 = GlobalKey();
  GlobalKey showCase_2= GlobalKey();


  //向下翻一页
  updateNextPage() {
    pageController.value
        .nextPage(duration: Duration(milliseconds: 900), curve: Curves.ease);
  }

  //向上翻一页
  updatePreviousPage() {
    pageController.value.previousPage(
        duration: Duration(milliseconds: 900), curve: Curves.ease);
  }


  //新 刷新课表
  Future<void> onRefresh(String studentID, String nowCourseList,
      String showClassScheduleUUID) async {
    if (state.courseRefreshStatus.value == 1) return; //反正同时多次触发
    state.courseRefreshStatus.value = 1; //设置当前课表刷新状态为进行中
    try {
      animationController?.forward(); //同步按钮动画执行
      //同步拉取教务系统课表
      String newestCourse = await CourseUtil()
          .getAllCourseSemesterList(nowCourseList, CourseData.ansWeek.value);

      //获取本地最新课表数据
      ClassNewScheduleEntity? newestClassNewSchedule =
          await GetIt.I<ClassNewScheduleDao>()
              .findNewestClassNewSchedule(studentID, nowCourseList);

      //课表缓存逻辑执行
      await cacheClassSchedule(studentID, nowCourseList, newestCourse);
      //首次获取课表逻辑
      await firstClassScheduleLogic(
          studentID, nowCourseList, newestCourse, showClassScheduleUUID);
      //拉取显示最新课表逻辑
      await newestClassScheduleLogic(
          studentID, nowCourseList, newestCourse, newestClassNewSchedule);
      // ShareDateUtil().setWeekCourseList(newestCourse); //设置课表
    } catch (e) {
      ToastUtil.show('错误：${e.toString()}');
    }
    state.courseRefreshStatus.value = 0; //设置当前课表刷新状态为结束
    CourseData.weekCourseJson.refresh();
  }


  //新 用于缓存课表的
  cacheClassSchedule(
      String studentID, String semester, String classSchedule) async {
    //获取最新课表数据
    ClassNewScheduleEntity? newestClassSchedule =
        await GetIt.I<ClassNewScheduleDao>()
            .findNewestClassNewSchedule(studentID, semester);
    String scheduleMd5 = md5
        .convert(utf8.encode(jsonEncode(classSchedule).toString()))
        .toString(); //课表数据的md5码
    //如果没有任何一条记录那么直接先插入现在的数据
    if (newestClassSchedule == null) {
      //存入
      await GetIt.I<ClassNewScheduleDao>()
          .insertClassNewSchedule(ClassNewScheduleEntity(
                  uid: Uuid().v1(),
                  //UUID生成
                  studentId: studentID,
                  //用户学号
                  semester: semester,
                  //课表学期
                  dateTime: DateTime.now(),
                  //更新时间
                  md5: scheduleMd5,
                  //课表数据的md5值
                  json: classSchedule) //课表数据
              );
      return; //如果不存在最新的那么直接退出
    }

    //如果内容相同那么久不用更新了，说明当前就已经是最新课表
    if (scheduleMd5 == newestClassSchedule.md5) return;

    //如果数据不相同那么存入
    await GetIt.I<ClassNewScheduleDao>()
        .insertClassNewSchedule(ClassNewScheduleEntity(
                uid: Uuid().v1(),
                //UUID生成
                studentId: studentID,
                //用户学号
                semester: semester,
                //课表学期
                dateTime: DateTime.now(),
                //更新时间
                md5: scheduleMd5,
                //课表数据的md5值
                json: classSchedule) //课表数据
            );
  }


  //新 首次课表获取逻辑
  firstClassScheduleLogic(String studentID, String semester,
      String classSchedule, String showClassScheduleUUID) async {
    //获取最新课表数据
    ClassNewScheduleEntity? newestClassNewSchedule =
        await GetIt.I<ClassNewScheduleDao>()
            .findNewestClassNewSchedule(studentID, semester);
    if (showClassScheduleUUID == "") {
      //如果最新课表数据为空那么说明为第一次获取课表
      ShareDateUtil().setShowClassScheduleUUID(
          (newestClassNewSchedule?.uid)!); //设置当前课表显示的UUID
      ShareDateUtil().setWeekCourseJson(classSchedule); //直接显示这个课表
    }
  }


  //新 最新课表显示逻辑
  newestClassScheduleLogic(
      String studentID,
      String semester,
      String classSchedule,
      ClassNewScheduleEntity? localNestScheduleEntity) async {
    //获取最新课表数据
    ClassNewScheduleEntity? newestClassSchedule =
        await GetIt.I<ClassNewScheduleDao>()
            .findNewestClassNewSchedule(studentID, semester);
    if (newestClassSchedule!.dateTime == localNestScheduleEntity!.dateTime)
      return; //如果没有刷新新的课表，直接跳过即可。
    log('触发更新');
    ShareDateUtil()
        .setShowClassScheduleUUID((newestClassSchedule?.uid)!); //设置当前课表显示的UUID
    ShareDateUtil().setWeekCourseJson(classSchedule); //直接显示这个课表
  }



  //新 显示指定UUID课表逻辑
  showClassScheduleForUUID(String UUID) async {
    ClassNewScheduleEntity? classSchedule =
        await GetIt.I<ClassNewScheduleDao>().findClassNewScheduleForUid(UUID);
    ShareDateUtil()
        .setShowClassScheduleUUID((classSchedule?.uid)!); //设置当前课表显示的UUID
    ShareDateUtil().setWeekCourseJson((classSchedule?.json)!); //直接显示这个课表
  }



  //新 显示历史变动课表项组件
  showClassScheduleHistory(String studentID, String semester) async {
    List<ClassNewScheduleEntity> scheduleList =
        await GetIt.I<ClassNewScheduleDao>()
            .findAllClassNewScheduleForStudentIdAndSemester(
                studentID, semester);
    showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (builder) {
          return MediaQuery(data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0), child: Scaffold(
            backgroundColor: Colors.transparent,
            body: InkWell(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      // color: Color.fromARGB(255, 247, 242, 249),
                    color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['shadowColor'] as List),
                            blurRadius: 10,
                            offset: Offset(1, 1))
                      ]),
                  height: 300,
                  width: 260,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: scheduleList.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                String timeForm =
                                    '${formatDate(scheduleList[index].dateTime!, [
                                  yyyy,
                                  '-',
                                  mm,
                                  '-',
                                  dd,
                                  '  ',
                                  HH,
                                  ':',
                                  mm
                                ])}';
                                return InkWell(
                                  child: Container(
                                    height: 60,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '更新时间：${timeForm}',
                                              style: TextStyle(
                                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                                                  fontSize: 12),
                                            ),
                                            Visibility(
                                              child: Text(
                                                ' (当前)',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                              visible: CourseData
                                                  .showClassScheduleUUID
                                                  .value ==
                                                  scheduleList[index].uid,
                                            )
                                          ],
                                        ),
                                        Text(
                                            '课表UID值：${scheduleList[index].uid}',
                                            style: TextStyle(
                                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                                                fontSize: 8)),
                                        Text(
                                            '课表MD5值：${scheduleList[index].md5}',
                                            style: TextStyle(
                                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                                                fontSize: 8))
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    showClassScheduleForUUID(
                                        (scheduleList[index]?.uid)!);
                                    Navigator.pop(builder); //退出弹窗
                                    Get.snackbar(
                                      "课表通知",
                                      "已选择${timeForm}历史缓存课表",
                                      duration: Duration(milliseconds: 1500),
                                    );
                                  },
                                );
                              }),
                          flex: 1,
                        ),
                        Container(
                          width: MediaQuery.of(builder).size.width,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(builder);
                              },
                              child: Text('取消')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(builder);
                Get.back();
              },
            ),
          ));
        });
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 课表数据与控件之间的数据适配器
   * [date] 11:49 2024/7/17
   * [param] null
   * [return]
   */
  tableAdapter(List<dynamic> courses) {
    Map<String, dynamic> result = {"tables": []};
    // log(jsonEncode(courses));
    // log('${courses.length}');
    for (int x = 0; x < courses[0].length; ++x) {
      // log(jsonEncode(courses));
      //横向
      String repeat = "[]";
      int rowStart = 0;
      int rowEnd = 0;
      int columStart = 0;
      int columEnd = 0;
      for (int y = 0; y < courses.length; ++y) {
        //竖向
        String inform = jsonEncode(courses[y][x]);
        if (repeat != inform || y == 4) {
          if (repeat != "[]" && columStart != 0 ) {
            // log(repeat);
            result['tables'].add({
              "rowStart": rowStart + 1,
              "rowEnd": rowEnd + 1,
              "columStart": columStart,
              "columEnd": columEnd,
              "title":
                  "${jsonDecode(repeat).length > 1 ? "有多门课程同时进行，点击查看详细" : jsonDecode(repeat)[0]['courseName']}",
              "style": {
                "textColor": jsonDecode(repeat).length > 1
                    ? [255, 255, 0, 0]
                    : [255, 0, 0, 0]
              },
              "data": jsonDecode(repeat)
            });
          }
          rowStart = y;
          rowEnd = y;
          columStart = x + 1;
          columEnd = x + 1;
          repeat = inform;
        } else {
          rowEnd = rowEnd < y ? y : rowEnd;
        }
        if (repeat != '[]' && y == courses.length - 1) {
          if (repeat != "[]" && columStart != 0) {
            // log(repeat);
            result['tables'].add({
              "rowStart": rowStart + 1,
              "rowEnd": rowEnd + 1,
              "columStart": columStart,
              "columEnd": columEnd,
              "title":
                  "${jsonDecode(repeat).length > 1 ? "有多门课程同时进行，点击查看详细" : jsonDecode(repeat)[0]['courseName']}",
              "style": {
                "textColor": jsonDecode(repeat).length > 1
                    ? [255, 255, 0, 0]
                    : [255, 0, 0, 0]
              },
              "data": jsonDecode(repeat)
            });
          }
          rowStart = y;
          rowEnd = y;
          columStart = x + 1;
          columEnd = x + 1;
          repeat = inform;
          continue;
        }
      }
    }

    return result;
  }

  //用来陈列数据列表或者刷新课表视图用
  List<Widget> pullAllCourseSchedule(Map<dynamic, dynamic> courseJson) {
    // log(jsonEncode(courseJson));
    remark.value = courseJson['remark']!;
    //开学时间
    DateTime startSchoolTime = DateTime(
        int.parse(CourseData.schoolOpenTime.value.split('/')[0]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[1]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[2]));
    List courses = courseJson["courses"];
    // log(jsonEncode(courses[4]));
    List<Widget> scheduleList = [];
    // log(courses.toString());
    for (int i = 0; i < courses.length; ++i) {
      scheduleList.add(ClassScheduleWidget(
        tableJson: tableAdapter(courses[i]),
        isNoon: CourseData.isNoonLineSwitch,
        isMin: CourseData.isMinForSchedule,
        isColor: CourseData.isColorClassSchedule,
        rowTimeList: CourseData.courseTime.value
            .map((element) => {
                  "start": TimeOfDay(
                      hour: int.parse(element.split('-')[0].split(':')[0]),
                      minute: int.parse(element.split('-')[0].split(':')[1])),
                  "end": TimeOfDay(
                      hour: int.parse(element.split('-')[1].split(':')[0]),
                      minute: int.parse(element.split('-')[1].split(':')[1]))
                })
            .toList(),
        // columTimeList: [],
        columTimeList: [
          startSchoolTime.add(Duration(days: 7 * i)),
          startSchoolTime.add(Duration(days: 7 * i + 1)),
          startSchoolTime.add(Duration(days: 7 * i + 2)),
          startSchoolTime.add(Duration(days: 7 * i + 3)),
          startSchoolTime.add(Duration(days: 7 * i + 4)),
          startSchoolTime.add(Duration(days: 7 * i + 5)),
          startSchoolTime.add(Duration(days: 7 * i + 6)),
        ],
      ));
    }

    return scheduleList;
  }

  //测试新课表的数据加载与显示
  debugCoursePullTest() {
    CourseUtil()
        .getAllCourseSemesterList(
            "${CourseData.nowCourseList.value}", CourseData.ansWeek.value)
        .then((value) {
      state.debugCourseJson.value = jsonDecode(value);
      state.debugCourseJson.refresh();
    });
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 摇一摇返回当前周
   * [date] 17:19 2024/3/20
   * [param] null
   * [return]
   */
  shakeListen() {
    _streamSubscriptions
        .add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      //不受重力的影响
      // print("event的值${event}");
      int value = 7;
      if (event.x >= value ||
          event.x <= -value ||
          event.y >= value ||
          event.y <= -value ||
          event.z >= value ||
          event.z <= -value) {
        if (pageController.value.hasClients &&
            CourseData.isShakeToNowSchedule.value)
          pageController.value.animateToPage(CourseData.nowWeek.value - 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate);
      }
    }));
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 课表图片分享
   * [date] 13:24 2024/3/22
   * [param] null
   * [return]
   */
  Future<String?> capturePngFilePath(globalKey) async {
    // TencentKitPlatform.instance.shareText(
    //   scene: TencentScene.kScene_QQ,
    //   summary: '分享测试',
    // );
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      double dpr = ui.window.devicePixelRatio; // 获取当前设备的像素比
      ui.Image image = await boundary.toImage(pixelRatio: dpr);
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
    RenderRepaintBoundary? boundary = courseWidgetKey.currentContext!
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
   * [description] //TODO 用于监听课表刷新的
   * [date] 19:47 2024/6/9
   * [param] null
   * [return]
   */
  void courseRefreshListen() {
    if (animationController == null)
      animationController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 2500));
    animationController
      ?..addStatusListener((status) {
        if (status == AnimationStatus.completed &&
            state.courseRefreshStatus.value == 1) {
          animationController?.reset();
          animationController?.forward();
        } else if (status == AnimationStatus.completed &&
            state.courseRefreshStatus.value != 1) {
          animationController?.reset();
        }
      });
  }

  //第几周的快速选择卡
  weekChooseWidgetList(_context) {
    List<Widget> list = [];
    for (int i = 0; i < CourseData.ansWeek.value; ++i) {
      list.add(Obx(() => InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: pageController.value.page == i
                      ? Color.fromARGB(255, 250, 203, 164)
                      : Color.fromARGB(100, 255, 255, 255)),
              child: Center(
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                      color: pageController.value.page == i
                          ? Color.fromARGB(255, 253, 103, 103)
                          : Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
            onTap: () {
              // pageController.value.jumpToPage(i);
              pageController.value.animateToPage(i,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              pageController.refresh();
              Navigator.pop(_context);
            },
          )));
    }
    return list;
  }
  someEvent()async{
    await Future.delayed(Duration(seconds: 3),);
    ShowCaseWidget.of(showCaseContext!).startShowCase([showCase_1,showCase_2]);
  }

  @override
  void onInit() {
    // someEvent();
    // refreshAllCourseTable(CourseData.oldWeekCourseList.value);
    // debugCoursePullTest(); //debug加载测试数据
    courseRefreshListen();
    //每次进入课表都进行一次课表同步

    onRefresh(AccountData.studentID, CourseData.nowCourseList.value,
          CourseData.showClassScheduleUUID.value);


    shakeListen();
  }

  @override
  void onClose() {
    _streamSubscriptions.forEach((element) {
      element.cancel();
    }); //删除所有摇一摇
  }
}
