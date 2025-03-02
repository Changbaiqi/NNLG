import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee/marquee.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/showCourseSharedSelectDialog.dart';
import 'package:callo/view/router/Routes.dart';
import 'package:showcaseview/showcaseview.dart';

import 'logic.dart';

class MainCourseViewPage extends StatelessWidget {
  MainCourseViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainCourseViewLogic());

  final state = Get.find<MainCourseViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return ShowCaseWidget(
      builder: (showCaseContext){
        logic.showCaseContext = showCaseContext;
        return Obx(() => Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                // color: Color.fromARGB(255, 255, 251, 254),
                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List),
                // color: Colors.white
              ),
              child: Obx(() => Stack(
                children: [
                  Opacity(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.network(
                        'https://t.mwm.moe/fj/',
                        fit: BoxFit.cover,
                      ),
                    ),
                    opacity: CourseData.isPictureBackground.value &&
                        CourseData.isRandomQuadraticBackground.value
                        ? CourseData.courseBackgroundOpacity.value
                        : 0,
                  ),
                  Opacity(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CourseData.courseBackgroundInputUrl.value != null
                          ? Image.network(
                        CourseData.courseBackgroundInputUrl.value,
                        fit: BoxFit.cover,
                      )
                          : Container(),
                    ),
                    opacity: CourseData.isPictureBackground.value &&
                        CourseData.isUrlBackground.value
                        ? CourseData.courseBackgroundOpacity.value
                        : 0,
                  ),
                  Opacity(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: CourseData.courseBackgroundFilePath.value != null
                          ? Image.file(
                        File(CourseData.courseBackgroundFilePath.value),
                        fit: BoxFit.cover,
                      )
                          : Container(),
                    ),
                    opacity: CourseData.isPictureBackground.value &&
                        CourseData.isCustomerLocalBackground.value
                        ? CourseData.courseBackgroundOpacity.value
                        : 0,
                  )
                ],
              )),
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                leading: Showcase(
                  key: logic.showCase_1,
                  description: '在这里进行课表的相关设置哦。\n1、调整每日上课时间\n2、调整不同学期课表\n3、调整开学日期使其课表能对上日程\n4、设置课表背景图片等',
                  child: IconButton(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.settings,
                          // color: Colors.black,
                          color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                          size: 20,
                        ),
                        Text(
                          '课表设置',
                          style: TextStyle(fontSize: 8,
                              // color: Colors.black
                              color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)
                          ),
                        )
                      ],
                    ),
                    onPressed: () {
                      Get.toNamed(Routes.CourseSet);
                    },
                  ),
                ),
                // backgroundColor: Colors.white,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                elevation: 1,
                title: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Obx(() => InkWell(
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Text(
                                          '第 ${state.nowIndex.value} 周',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: state.nowIndex.value ==
                                                  CourseData.nowWeek.value
                                                  ? CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['nowWeekColor'] as List)
                                                  : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['nonNowWeekColor'] as List)),
                                        ),
                                        Text(
                                          '${CourseData.nowCourseList.value}',
                                          style: TextStyle(fontSize: 12,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      barrierColor: Colors.transparent,
                                      builder: (builder) {
                                        return Dialog(
                                          child: Container(
                                            height: 250,
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 231, 231, 231),
                                                borderRadius:
                                                BorderRadius.circular(20)),
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 10),
                                              child: ListView(
                                                children: [
                                                  Wrap(
                                                    spacing: 5,
                                                    runSpacing: 5,
                                                    alignment:
                                                    WrapAlignment.center,
                                                    children: logic
                                                        .weekChooseWidgetList(
                                                        builder),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              )),
                            ],
                          ),
                        ]),
                  ],
                ),
                actions: [
                  IconButton(
                    icon: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RotationTransition(
                          turns: Tween(begin: 0.0, end: 1.0)
                              .animate(logic.animationController!),
                          child: Icon(
                            Icons.cached_sharp,
                            color: state.courseRefreshStatus.value == 1
                                ? CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['synIconColor'] as List)
                                : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
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
                                  ? CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['synIconColor'] as List)
                                  : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                        )
                      ],
                    )),
                    onPressed: () async {
                      if (state.courseRefreshStatus.value == 1) return; //防止重叠触发
                      Get.snackbar(
                        "课表通知",
                        "正在同步官网课表...",
                        duration: Duration(milliseconds: 1500),
                      );

                      logic
                          .onRefresh(
                          AccountData.studentID,
                          CourseData.nowCourseList.value,
                          CourseData.showClassScheduleUUID.value)
                          .then((value) => Get.snackbar(
                        "课表通知",
                        "同步完毕",
                        duration: const Duration(milliseconds: 1500),
                      ));
                    },
                  ),
                  Showcase(key: logic.showCase_2, description: "这里可以查看课表与教务系统的同步历史，并且还可以选择回溯到指定同步时间课表查看", child: IconButton(
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.update,
                          color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                          size: 20,
                        ),
                        Text(
                          '同步历史',
                          style: TextStyle(fontSize: 8, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                        )
                      ],
                    ),
                    onPressed: () async {
                      logic.showClassScheduleHistory(
                          AccountData.studentID, CourseData.nowCourseList.value);
                    },
                  )),
                  PopupMenuButton(
                    color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List),
                    position: PopupMenuPosition.under,
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.menu,
                          color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                          size: 20,
                        ),
                        Text(
                          '更多',
                          style: TextStyle(fontSize: 8, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                        )
                      ],
                    ),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face_retouching_natural,
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  '共享课表',
                                  style:
                                  TextStyle(fontSize: 12, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                ),
                              )
                            ],
                          ),
                          value: '共享课表',
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.build,
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  '当前页设为本周',
                                  style:
                                  TextStyle(fontSize: 12, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                ),
                              )
                            ],
                          ),
                          value: '设为本周',
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.update,
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  '课表同步历史',
                                  style:
                                  TextStyle(fontSize: 12, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                ),
                              )
                            ],
                          ),
                          value: '课表同步历史',
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
                                .then((value) => CourseData.nowWeek.value =
                                CourseUtil.getNowWeek(
                                    CourseData.schoolOpenTime.value,
                                    CourseData.ansWeek.value));
                          }
                          break;
                        case '课表同步历史':
                          {
                            logic.showClassScheduleHistory(AccountData.studentID,
                                CourseData.nowCourseList.value);
                          }
                          break;
                      }
                    },
                  )
                ],
              ),
              body: Obx(
                    () => RepaintBoundary(
                    key: logic.courseWidgetKey,
                    child: Column(
                      children: [
                        Obx(() => Visibility(
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Color.fromARGB(180, 255, 242, 132)
                            ),
                            height: 20,
                            child: Row(
                              children: [
                                Obx(() => Container(
                                  width: Get.context!.width,
                                  child: Marquee(
                                    text: '备注：${logic.remark.value}',
                                    style: TextStyle(fontSize: 13,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                    velocity: 30.0,
                                    blankSpace: 20,
                                    pauseAfterRound: Duration(seconds: 5),
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                  ),
                                ))
                              ],
                            ),
                          ),
                          visible: logic.remark.value != "",
                        )),
                        Expanded(
                          child: PageView(
                            onPageChanged: (int index) {
                              state.nowIndex.value = index;
                              state.nowIndex.value += 1;
                              // print('当前页面时$index');
                            },
                            reverse: false,
                            scrollDirection: Axis.horizontal,
                            controller: logic.pageController.value,
                            children:
                            CourseData.weekCourseJson.value["courses"] != null
                                ? logic.pullAllCourseSchedule(CourseData.weekCourseJson): [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.asset('assets/images/shareLoadingLottie.json',
                                      height: 100, width: 200),
                                  Text("课表加载中......",style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),),
                                  ConstrainedBox(constraints: BoxConstraints(
                                    maxWidth: 250,
                                  ),child: Text('tips:若长时间未加载，可尝试在左上角课表设置中重新选择一下“学期课表”',maxLines: 5,softWrap: true,style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),),)
                                ],
                              )
                            ],
                          ),
                          flex: 1,
                        )
                      ],
                    )),
              ),
            ),
          ],
        ));
      },
    );
  }
}
