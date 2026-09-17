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
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/showCourseSharedSelectDialog.dart';
import 'package:callo/view/module/showCourseWidgetDialog.dart';
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
                        // 'https://t.mwm.moe/fj/',
                        'https://img.xjh.me/random_img.php?type=bg&ctype=nature&return=302',
                        fit: BoxFit.cover,
                        gaplessPlayback: true,
                        cacheWidth: _bgCacheWidth(context),
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        frameBuilder: (context, child, frame, wasSync) {
                          if (wasSync) return child;
                          return AnimatedOpacity(
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            child: child,
                          );
                        },
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
                        gaplessPlayback: true,
                        cacheWidth: _bgCacheWidth(context),
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
                        gaplessPlayback: true,
                        cacheWidth: _bgCacheWidth(context),
                        errorBuilder: (_, __, ___) => const SizedBox.shrink(),
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
                    icon: _CourseIconTextAction(
                      icon: Icons.settings,
                      label: '课表设置',
                      iconColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                      labelColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
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
                title: MediaQuery.withClampedTextScaling(
                  maxScaleFactor: 1.3,
                  child: Column(
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
                                              fontWeight: state.nowIndex.value ==
                                                      CourseData.nowWeek.value
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
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
                                      useRootNavigator: false,
                                      context: context,
                                      barrierColor: Colors.black
                                          .withValues(alpha: .35),
                                      builder: (builder) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          insetPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 24),
                                          child: GlassCard(
                                            page: 'main_course_view',
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 16, 16, 12),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GlassSectionTitle(
                                                    page: 'main_course_view',
                                                    title: '选择周次'),
                                                const SizedBox(height: 12),
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                          maxHeight: 300),
                                                  child: SingleChildScrollView(
                                                    child: Wrap(
                                                      spacing: 8,
                                                      runSpacing: 8,
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: logic
                                                          .weekChooseWidgetList(
                                                              builder),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                ),
                actions: [
                  IconButton(
                    icon: Obx(() => _CourseIconTextAction(
                      icon: Icons.cached_sharp,
                      label: state.courseRefreshStatus.value == 1
                          ? '课表同步中'
                          : '课表同步',
                      iconColor: state.courseRefreshStatus.value == 1
                          ? CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['synIconColor'] as List)
                          : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                      labelColor: state.courseRefreshStatus.value == 1
                          ? CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['synIconColor'] as List)
                          : CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                      iconRotation: Tween(begin: 0.0, end: 1.0)
                          .animate(logic.animationController!),
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
                    icon: _CourseIconTextAction(
                      icon: Icons.update,
                      label: '同步历史',
                      iconColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                      labelColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
                    ),
                    onPressed: () async {
                      logic.showClassScheduleHistory(
                          AccountData.studentID, CourseData.nowCourseList.value);
                    },
                  )),
                  PopupMenuButton(
                    color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List),
                    surfaceTintColor: Colors.transparent,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                            color: GlassTheme.border('main_course_view'),
                            width: 1)),
                    menuPadding: const EdgeInsets.symmetric(vertical: 6),
                    position: PopupMenuPosition.under,
                    icon: _CourseIconTextAction(
                      icon: Icons.menu,
                      label: '更多',
                      iconColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                      labelColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List),
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
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
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
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                ),
                              )
                            ],
                          ),
                          value: '课表同步历史',
                        ),
                        PopupMenuItem(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.widgets_outlined,
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['defaultIconColor'] as List),
                                size: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: Text(
                                  '桌面课表小组件',
                                  style:
                                  TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List)),
                                ),
                              )
                            ],
                          ),
                          value: '桌面课表小组件',
                        )
                      ];
                    },
                    onSelected: (v) {
                      switch (v) {
                        case '共享课表':
                          {
                            showDialog(
                                useRootNavigator: false,
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
                        case '桌面课表小组件':
                          {
                            showCourseWidgetDialog();
                          }
                          break;
                      }
                    },
                  )
                ],
              ),
              body: Obx(
                    () {
                  logic.trackCourseViewDeps();
                  final Map courseJson =
                      (CourseData.weekCourseJson.value as Map?) ?? {};
                  final courses = courseJson["courses"];
                  logic.syncRemark(courseJson);
                  return RepaintBoundary(
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
                          child: courses is List && courses.isNotEmpty
                              ? PageView.builder(
                                  onPageChanged: (int index) {
                                    state.nowIndex.value = index;
                                    state.nowIndex.value += 1;
                                    // print('当前页面时$index');
                                  },
                                  reverse: false,
                                  scrollDirection: Axis.horizontal,
                                  controller: logic.pageController.value,
                                  itemCount: courses.length,
                                  itemBuilder: (context, index) =>
                                      logic.buildWeekPage(index),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        'assets/images/shareLoadingLottie.json',
                                        height: 100,
                                        width: 200),
                                    Text(
                                      "课表加载中......",
                                      style: TextStyle(
                                          color: CustomerThemeUtil.setColor(CustomThemeData
                                              .nowThemeData
                                              .value['main_course_view']!['textColor'] as List)),
                                    ),
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth: 250,
                                      ),
                                      child: Text(
                                        'tips:若长时间未加载，可尝试在左上角课表设置中重新选择一下“学期课表”',
                                        maxLines: 5,
                                        softWrap: true,
                                        style: TextStyle(
                                            color: CustomerThemeUtil.setColor(CustomThemeData
                                                .nowThemeData
                                                .value['main_course_view']!['textColor'] as List)),
                                      ),
                                    )
                                  ],
                                ),
                          flex: 1,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ));
      },
    );
  }
}

//背景图按屏幕宽度降采样解码，降低内存占用
int _bgCacheWidth(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final dpr = MediaQuery.of(context).devicePixelRatio;
  return (size.width * dpr).round().clamp(1, 4096).toInt();
}

/// AppBar 图标+文字按钮：钳制文字缩放并自适应高度，避免系统大字体下竖向溢出
class _CourseIconTextAction extends StatelessWidget {
  const _CourseIconTextAction({
    required this.icon,
    required this.label,
    this.iconColor,
    this.labelColor,
    this.iconRotation,
  });

  final IconData icon;
  final String label;
  final Color? iconColor;
  final Color? labelColor;
  final Animation<double>? iconRotation;

  @override
  Widget build(BuildContext context) {
    Widget iconWidget = Icon(icon, color: iconColor, size: 20);
    if (iconRotation != null) {
      iconWidget = RotationTransition(turns: iconRotation!, child: iconWidget);
    }
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.3,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(fontSize: 8, color: labelColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
