import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/view/module/showCourseSharedSelectDialog.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class MainCourseViewPage extends StatelessWidget {
  MainCourseViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainCourseViewLogic());

  // final logic = Get.find<MainCourseViewLogic>();
  final state = Get
      .find<MainCourseViewLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 251, 254),
            // color: Colors.white
          ),
          child: Obx(() => Stack(
            children: [
              Opacity(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network('https://t.mwm.moe/fj/',fit: BoxFit.cover,),
                ),
                opacity: CourseData.isPictureBackground.value && CourseData.isRandomQuadraticBackground.value?CourseData.courseBackgroundOpacity.value:0,
              ),
              Opacity(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.network(CourseData.courseBackgroundInputUrl.value,fit: BoxFit.cover,),
                ),
                opacity: CourseData.isPictureBackground.value && CourseData.isUrlBackground.value?CourseData.courseBackgroundOpacity.value:0,
              ),
              Opacity(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Image.file(File(CourseData.courseBackgroundFilePath.value),fit: BoxFit.cover,),
                ),
                opacity: CourseData.isPictureBackground.value && CourseData.isCustomerLocalBackground.value?CourseData.courseBackgroundOpacity.value:0,
              )
            ],
          )),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
              icon: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: 20,
                  ),
                  Text(
                    '课表设置',
                    style: TextStyle(fontSize: 8, color: Colors.black),
                  )
                ],
              ),
              onPressed: () {
                Get.toNamed(Routes.CourseSet);
              },
            ),
            // backgroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 1,
            title: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Row(
                    children: [
                      Obx(() =>
                          Column(
                            children: [
                              Text(
                                '第 ${state.nowIndex.value} 周',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: state.nowIndex.value ==
                                        CourseData.nowWeek.value
                                        ? Colors.black
                                        : Colors.redAccent),
                              ),
                              Text(
                                '${CourseData.nowCourseList.value}',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          )),
                    ],
                  ),
                ]),
              ],
            ),
            actions: [
              IconButton(
                icon: Obx(() =>
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(logic.animationController!),
                          child: Icon(
                            Icons.cached_sharp,
                            color: state.courseRefreshStatus.value == 1
                                ? Colors.red
                                : Colors.black,
                            size: 20,
                          ),
                        ),
                        Text(
                          state.courseRefreshStatus.value == 1
                              ? '课表同步中'
                              : '课表同步',
                          style: TextStyle(
                              fontSize: 8,
                              color: state.courseRefreshStatus.value == 1
                                  ? Colors.red
                                  : Colors.black),
                        )
                      ],
                    )),
                onPressed: () {
                  if(state.courseRefreshStatus==1) return; //防止重叠触发
                  Get.snackbar(
                    "课表通知",
                    "正在同步官网课表...",
                    duration: Duration(milliseconds: 1500),
                  );
                  logic.onRefresh().then((value) =>
                      Get.snackbar(
                        "课表通知",
                        "同步完毕",
                        duration: const Duration(milliseconds: 1500),
                      ));
                },
              ),
              IconButton(
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      '分享',
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    )
                  ],
                ),
                onPressed: () async {
                  logic.capturePngFilePath(logic.courseWidgetKey); //图片分享
                  // logic.savePhoto(); //存储到本地
                  // logic.savePhoto();
                },
              ),
              PopupMenuButton(
                position: PopupMenuPosition.under,
                icon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      '更多',
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    )
                  ],
                ),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.face_retouching_natural,
                            color: Colors.black,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '共享课表',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      value: '共享课表',
                    ),
                    PopupMenuItem(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.build,
                            color: Colors.black,
                            size: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              '设为本周',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      value: '设为本周',
                    )
                  ];
                },
                onSelected: (v) {
                  switch (v) {
                    case '共享课表':
                      {
                        showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (contxt) {
                              return Center(
                                child: showCourseSharedSelectDialog(),
                              );
                            });
                      }
                      break;
                    case '设为本周':
                      {
                        DateTime now = DateTime.now();
                        int weekDay = now.weekday;
                        int diff = (state.nowIndex.value - 1) * 7 + weekDay - 1;
                        now = now.add(Duration(days: -1 * diff));
                        //设置周数
                        ShareDateUtil()
                            .setSchoolOpenDate(
                            "${now.year}/${now.month}/${now.day}")
                            .then((value) =>
                        CourseData.nowWeek.value =
                            CourseUtil.getNowWeek(
                                CourseData.schoolOpenTime.value,
                                CourseData.ansWeek.value));
                      }
                      break;
                  }
                },
              )
            ],
          ),
          body: Obx(
                () =>
                RepaintBoundary(
                    key: logic.courseWidgetKey,
                    child: Container(
                      decoration: BoxDecoration(
                        // color: Color.fromARGB(255, 255, 251, 254),
                        color: Colors.transparent
                      ),
                      height: MediaQuery
                          .of(context)
                          .size
                          .height,
                      child: PageView(
                        onPageChanged: (int index) {
                          state.nowIndex.value = index;
                          state.nowIndex.value += 1;
                          // print('当前页面时$index');
                        },
                        reverse: false,
                        scrollDirection: Axis.horizontal,
                        controller: logic.pageController,
                        children: CourseData.weekCourseList.value.length != 0
                            ? logic
                            .refreshAllCourseTable(CourseData.weekCourseList.value)
                            : [
                          Center(
                            child: Text("课表加载中......"),
                          )
                        ],
                      ),
                    )),
          ),
        ),
      ],
    );
  }
}
