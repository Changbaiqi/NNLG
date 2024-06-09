import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/WeekDayForm.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/view/module/showCourseTableMessage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shake_animation_widget/shake_animation_widget.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tencent_kit/tencent_kit.dart';

import 'state.dart';

class MainCourseViewLogic extends GetxController with SingleGetTickerProviderMixin{
  final MainCourseViewState state = MainCourseViewState();
  BuildContext? context;

  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  final courseWidgetKey = GlobalKey(); //课表key

  AnimationController? animationController=null;

  Widget loading = Center(
    child: Text(
      'Loading...',
      style: TextStyle(fontSize: 10),
    ),
  );

  final PageController pageController = PageController(
    initialPage: CourseData.nowWeek.value - 1,
  );

  //向下翻一页
  updateNextPage() {
    pageController.nextPage(
        duration: Duration(milliseconds: 900), curve: Curves.ease);
  }

  //向上翻一页
  updatePreviousPage() {
    pageController.previousPage(
        duration: Duration(milliseconds: 900), curve: Curves.ease);
  }

  //刷新课表
  Future<void> onRefresh() async {
    if(state.courseRefreshStatus.value==1) return; //反正同时多次触发
    state.courseRefreshStatus.value=1;
    animationController?.forward();
    await CourseUtil()
        .getAllCourseWeekList("${CourseData.nowCourseList.value}");
    state.courseRefreshStatus.value=0;
  }

  //如果出现Each Child must be laid out exactly once那么很大可能bug出现在这里！！！！！！！！！！！！！！
  //用来陈列数据列表或者刷新课表视图用
  List<Widget> refreshAllCourseTable(List<String> allList) {
    // print(allList);
    // int ans =0;
    // for(String str in allList){
    //   log("第${++ans}周课表"+str);
    // }

    //开学时间
    DateTime startSchoolTime = DateTime(
        int.parse(CourseData.schoolOpenTime.value.split('/')[0]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[1]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[2]));

    //临时存储courseWeek列表变量
    List<Widget> _resCourseWeek = [];
    for (int i = 0; i < allList.length; ++i) {
      List _courseList = [];

      List json = jsonDecode(allList[i]);
      List _resCourseList = [];
      for (int x = 0; x < json.length; ++x) {
        if (i == 6) {
          // debugPrint("这是第${x + 1}周");
          // debugPrint("${json[x]}");
        }

        for (int y = 0; y < json[x].length; ++y) {
          // print(json[x][y]);
          //判断是否为空课
          for (int z = 0; z < json[x][y].length; ++z) {
            //添加授课时间json
            (json[x][y][z] as LinkedHashMap<String, dynamic>)
                .addAll({"courseTime": "${CourseData.courseTime.value[x]}"});
          }
          _resCourseList.add(courseTableWidget(json[x][y] ?? "无课",
              startSchoolTime.add(Duration(days: y) /*传入相应的授课日期*/)));
        }
      }

      //直接替换
      _courseList.clear();
      _courseList = _resCourseList;

      //其中的courseTable就是创建一个课表页面
      _resCourseWeek.add(courseTable(_courseList, startSchoolTime));
      startSchoolTime = startSchoolTime.add(Duration(days: 7));
    }

    //直接替换
    // state.courseWeek.value.clear();
    // state.courseWeek.value = _resCourseWeek;
    // state.courseWeek.refresh();

    // state.viewPageVar.value = viewPage();
    // state.viewPageVar.refresh();
    // ShareDateUtil().setWeekCourseList(CourseData.weekCourseList.value);
    return _resCourseWeek;
  }

  //用于刷新列表控件用的
  void loadCourseTable() {
    if (CourseData.weekCourseList.value == null ||
        CourseData.weekCourseList.value.length == 0) {
      Future.wait([
        CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList.value}"),
      ]).then((value) {
        //获取到数据后刷新
        refreshAllCourseTable(CourseData.weekCourseList.value);
      });
    } else {
      refreshAllCourseTable(CourseData.weekCourseList.value);
    }
  }

  //表格内每一项的组件
  Widget courseTableWidget(courseJSON, DateTime dateTime /*传入相应的授课日期*/,
      {Color? color}) {
    ShakeAnimationController _shakeAnimationController =
        new ShakeAnimationController();
    // if((dateTime.month == DateTime.now().month) &&
    //     (dateTime.day == DateTime.now().day)){
    //   Timer.periodic(Duration(seconds: 2),(Timer timer)=>_shakeAnimationController.start(shakeCount: 1));
    // }
    return courseJSON.length == 0
        ? Center(
            child: Text(
              '无课',
              style: TextStyle(fontSize: 12),
            ),
          )
        : ShakeAnimationWidget(
            shakeAnimationController: _shakeAnimationController,
            isForward: false,
            shakeAnimationType: ShakeAnimationType.SkewShake,
            shakeCount: 0,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(2.5),
                child: Container(
                  decoration: new BoxDecoration(
                    //背景
                    color: !CourseData.isColorClassSchedule.value
                        ? Color.fromARGB(
                            (dateTime.month == DateTime.now().month) &&
                                    (dateTime.day == DateTime.now().day)
                                ? 130
                                : 30,
                            59,
                            52,
                            86)
                        : state.stringTurn16Color(
                            "${courseJSON.length > 1 ? "有多门课程同时进行，点击查看详细" : courseJSON[0]['courseName']}"),
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //设置四周边框
                    border: new Border.all(
                        width: 1, color: Color.fromARGB(80, 59, 52, 86)),
                  ),
                  child: InkWell(
                    child: Text(
                      '${courseJSON.length > 1 ? "有多门课程同时进行，点击查看详细" : courseJSON[0]['courseName']}',
                      style: TextStyle(
                          fontSize: 12,
                          color: courseJSON.length > 1
                              ? Colors.red
                              : Colors.black),
                    ),
                    onTap: () {
                      //ToastUtil.show('${courseJSON['courseName']}');
                      //debugPrint(courseJSON.toString());
                      // state.stringTurn16Color();
                      showCourseTableMessage(context)
                          .show(courseJSON, dateTime);
                    },
                  ),
                ),
              ),
            ));
  }

  List<TableRow> forWidgetList(List tableWidgetList) {
    List<TableRow> list = [];
    double defineBorderWidth = 0.1;
    //左侧日期
    for (int i = 0; i <= 5; ++i) {
      TableRow tableRow = TableRow(children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  '${i + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Text(
                  '${CourseData.courseTime.value[i].split("-")[0]}\n至\n${CourseData.courseTime.value[i].split("-")[1]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 1
              ? tableWidgetList[(i * 7) + 0]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 2
              ? tableWidgetList[(i * 7) + 1]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 3
              ? tableWidgetList[(i * 7) + 2]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 4
              ? tableWidgetList[(i * 7) + 3]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 5
              ? tableWidgetList[(i * 7) + 4]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 6
              ? tableWidgetList[(i * 7) + 5]
              : loading,
        ),
        Container(
          height: 100,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black54,width: defineBorderWidth)
          ),
          child: tableWidgetList.length >= (i * 7) + 7
              ? tableWidgetList[(i * 7) + 6]
              : loading,
        ),
      ]);
      list.add(tableRow);
    }

    //如果开启了分割线则添加
    if(CourseData.isNoonLineSwitch.value){
      list.insert(2, TableRow(
          children: [
            Container(),
            Container(),
            Container(),
            Container(child: Center(child: Text('午'),),),
            Container(),
            Container(child: Center(child: Text('休'),),),
            Container(),
            Container(),
          ]
      ));
    }
    return list;
  }

  /**
   *
   * 课表格子展示
   */
  Widget courseTable(List tableWidgetList, DateTime dateTime) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.transparent),
          children: [
            TableRow(children: [
              Text(''),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month == dateTime.month &&
                            DateTime.now().day == dateTime.day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month == dateTime.month &&
                            DateTime.now().day == dateTime.day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.weekday)}\n${dateTime.month}/${dateTime.day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 1)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 1)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 1)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 1)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 1)).weekday)}\n${dateTime.add(Duration(days: 1)).month}/${dateTime.add(Duration(days: 1)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 2)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 2)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 2)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 2)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 2)).weekday)}\n${dateTime.add(Duration(days: 2)).month}/${dateTime.add(Duration(days: 2)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 3)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 3)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 3)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 3)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 3)).weekday)}\n${dateTime.add(Duration(days: 3)).month}/${dateTime.add(Duration(days: 3)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 4)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 4)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 4)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 4)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 4)).weekday)}\n${dateTime.add(Duration(days: 4)).month}/${dateTime.add(Duration(days: 4)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 5)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 5)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 5)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 5)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 5)).weekday)}\n${dateTime.add(Duration(days: 5)).month}/${dateTime.add(Duration(days: 5)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                                dateTime.add(Duration(days: 6)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 6)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                                dateTime.add(Duration(days: 6)).month &&
                            DateTime.now().day ==
                                dateTime.add(Duration(days: 6)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 6)).weekday)}\n${dateTime.add(Duration(days: 6)).month}/${dateTime.add(Duration(days: 6)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ],
        ),
        Expanded(
          flex: 1,
          child: ListView(
            children: [
              Table(
                // border: TableBorder.all(color: Colors.black, width: 0.1),
                children: forWidgetList(tableWidgetList),
              )
            ],
          ),
        ),
      ],
    );
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
      int value = 4;
      if (event.x >= value ||
          event.x <= -value ||
          event.y >= value ||
          event.y <= -value ||
          event.z >= value ||
          event.z <= -value) {
        if (pageController.hasClients && CourseData.isShakeToNowSchedule.value)
          pageController.animateToPage(CourseData.nowWeek.value - 1,
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
  void courseRefreshListen(){
    if(animationController==null)animationController = AnimationController(vsync: this,duration: Duration(
        milliseconds: 2500
    ));
    animationController?..addStatusListener((status) {
      if(status == AnimationStatus.completed && state.courseRefreshStatus.value==1){
        animationController?.reset();
        animationController?.forward();
      }else if(status == AnimationStatus.completed && state.courseRefreshStatus.value!=1){
        animationController?.reset();
      }
    });
  }

  @override
  void onInit() {
    // refreshAllCourseTable(CourseData.weekCourseList.value);

    courseRefreshListen();
    //每次进入课表都进行一次课表同步
    onRefresh();
    shakeListen();

  }

  @override
  void onClose() {
    _streamSubscriptions.forEach((element) {
      element.cancel();
    }); //删除所有摇一摇
  }
}
