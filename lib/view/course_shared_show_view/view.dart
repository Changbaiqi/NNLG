import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/module/showCourseSharedSelectDialog.dart';

import 'logic.dart';

class CourseSharedShowViewPage extends StatelessWidget {
  CourseSharedShowViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedShowViewLogic>();
  final state = Get.find<CourseSharedShowViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    final Color textColor = GlassTheme.textColor('main_course_view');
    return GlassBackground(
      page: 'main_course_view',
      child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // automaticallyImplyLeading: false,
        elevation: 0,
        foregroundColor: textColor,
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
                      color: textColor,
                    ),
                    onPressed: () {
                      logic.updatePreviousPage();
                    },
                  ),
                  Obx(() => Text(
                    '${state.title.value}',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  )),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/end.png',
                      height: 25,
                      width: 25,
                      color: textColor,
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
                  border: Border.all(color: textColor.withValues(alpha: .2),width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                child: DropdownButton<String>(
                  isDense: true,
                    iconSize: 16,
                    underline: const SizedBox(),
                    dropdownColor: GlassTheme.pageBackground('main_course_view'),
                    value: state.selectSemester.value,
                    style: TextStyle(fontSize: 13, color: textColor),
                    items: state.semesterList.value
                        .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(e,style: TextStyle(fontSize: 13, color: textColor),),
                        )))
                        .toList(),
                    onChanged: (value) async {
                      state.selectSemester.value = value!;
                      await state.getShareCourseData(state.selectSemester.value);
                      // state.oldWeekCourseList.refresh();
                      // logic.showScoreList(state.selectTime.value);
                      // state.mfuture = logic.future();
                    }),
              ))
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
          children: state.oldWeekCourseList.value.length != 0
              ? logic.refreshAllCourseTable(state.oldWeekCourseList.value)
              : [
            Center(
              child: Text("课表加载中......",
                  style: TextStyle(
                      fontSize: 13, color: textColor.withValues(alpha: .6))),
            )
          ],
        ),
      )),
    ));
  }
}
