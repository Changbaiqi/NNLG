import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/view/module/showCourseSharedSelectDialog.dart';

import 'logic.dart';

class CourseSharedShowViewPage extends StatelessWidget {
  CourseSharedShowViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedShowViewLogic>();
  final state = Get.find<CourseSharedShowViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: false,
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
              Obx(() => Container(
                padding: EdgeInsets.fromLTRB(5, 5,5, 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black38,width: 2),
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
                child: DropdownButton<String>(
                  isDense: true,
                    iconSize: 16,
                    value: state.selectSemester.value,
                    items: state.semesterList.value
                        .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(e,style: TextStyle(fontSize: 15),),
                        )))
                        .toList(),
                    onChanged: (value) {
                      state.selectSemester.value = value!;
                      state.getShareCourseData(state.selectSemester.value);
                      // logic.showScoreList(state.selectTime.value);
                      // state.mfuture = logic.future();
                    }),
              ))
              // IconButton(
              //   icon: Column(
              //     children: [
              //       Icon(
              //         Icons.cached_sharp,
              //         color: Colors.black,
              //         size: 20,
              //       ),
              //       Text(
              //         '课表同步',
              //         style: TextStyle(fontSize: 8, color: Colors.black),
              //       )
              //     ],
              //   ),
              //   onPressed: () {
              //     Get.snackbar(
              //       "课表通知",
              //       "正在同步官网课表...",
              //       duration: Duration(milliseconds: 1500),
              //     );
              //     logic.onRefresh().then((value) => Get.snackbar(
              //       "课表通知",
              //       "同步完毕",
              //       duration: Duration(milliseconds: 1500),
              //     ));
              //     //ToastUtil.show('敬请期待...');
              //   },
              // )
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
              ? logic.refreshAllCourseTable(state.weekCourseList.value)
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
