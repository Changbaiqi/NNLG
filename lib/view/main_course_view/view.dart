import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/module/showCourseSharedSelectDialog.dart';
import 'package:nnlg/view/router/AppPages.dart';
import 'package:nnlg/view/router/Routes.dart';

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
                        '${state.title.value}',
                        style: TextStyle(color: Colors.black),
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
                        duration:const Duration(milliseconds: 1500),
                      ));
                  //ToastUtil.show('敬请期待...');
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
                  // Get.snackbar(
                  //   "功能通知",
                  //   "敬请期待...",
                  //   duration: Duration(milliseconds: 1500),
                  // );
                  // Get.toNamed(Routes.ShareCourseChoose);
                  // await showCourseSharedSelectDialog();
                  showDialog(
                      context: context,
                      barrierColor: Colors.transparent,
                      builder: (contxt) {
                        return Center(
                          child: showCourseSharedSelectDialog(),
                        );
                      });
                },
              )
            ]),
          ],
        ),
      ),
      body: Obx(() => Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              onPageChanged: (int index) {
                state.nowIndex.value = index;
                logic.updateTitle('第${index + 1}周');
                // print('当前页面时$index');
              },
              reverse: false,
              scrollDirection: Axis.horizontal,
              controller: logic.pageController,
              children: CourseData.weekCourseList.value.length != 0
                  ? logic.refreshAllCourseTable(CourseData.weekCourseList.value)
                  : [
                      Center(
                        child: Text("课表加载中......"),
                      )
                    ],
            ),
          )),
    );
  }
}
