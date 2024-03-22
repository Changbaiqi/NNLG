import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/view/module/showCourseSharedSelectDialog.dart';

import 'logic.dart';

class MainCourseViewPage extends StatelessWidget {
  MainCourseViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainCourseViewLogic());

  // final logic = Get.find<MainCourseViewLogic>();
  final state = Get.find<MainCourseViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/start.png',
                      height: 25,
                      width: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      logic.updatePreviousPage();
                    },
                  ),
                  Obx(() => Text(
                        '第${state.nowIndex.value}周',
                        style: TextStyle(color: state.nowIndex.value==CourseData.nowWeek.value?Colors.black:Colors.redAccent),
                      )),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/end.png',
                      height: 25,
                      width: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      logic.updateNextPage();
                    },
                  ),
                ],
              ),
              Container(
                width: 200,
                child: Row(
                  children: [
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.cached_sharp,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            '课表同步',
                            style: TextStyle(fontSize: 8, color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () {
                        Get.snackbar(
                          "课表通知",
                          "正在同步官网课表...",
                          duration: Duration(milliseconds: 1500),
                        );
                        logic.onRefresh().then((value) => Get.snackbar(
                          "课表通知",
                          "同步完毕",
                          duration: const Duration(milliseconds: 1500),
                        ));
                        //ToastUtil.show('敬请期待...');
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.build,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            '设为本周',
                            style: TextStyle(fontSize: 8, color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () async {
                        DateTime now = DateTime.now();
                        int weekDay = now.weekday;
                        int diff = (state.nowIndex.value-1)*7+weekDay-1;
                        now = now.add(Duration(days: -1*diff));
                        //设置周数
                        ShareDateUtil().setSchoolOpenDate("${now.year}/${now.month}/${now.day}").then((value) => CourseData.nowWeek.value = CourseUtil.getNowWeek(CourseData.schoolOpenTime.value, CourseData.ansWeek.value));
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(
                            Icons.face_retouching_natural,
                            color: Colors.black,
                            size: 20,
                          ),
                          Text(
                            '共享课表',
                            style: TextStyle(fontSize: 8, color: Colors.black),
                          )
                        ],
                      ),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (contxt) {
                              return Center(
                                child: showCourseSharedSelectDialog(),
                              );
                            });
                      },
                    ),
                    IconButton(
                      icon: Column(
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
                    )
                  ],
                ),
              )
            ]),
          ],
        ),
      ),
      body: Obx(
        () => RepaintBoundary(
            key: logic.courseWidgetKey,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 251, 254)
              ),
              height: MediaQuery.of(context).size.height,
              child: PageView(
                onPageChanged: (int index) {
                  state.nowIndex.value = index;
                  state.nowIndex.value +=1;
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
    );
  }
}
