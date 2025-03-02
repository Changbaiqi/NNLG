import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/selectBeginCourseTimeSheet.dart';
import 'package:callo/view/module/selectCourseTimeSheet.dart';
import 'package:callo/view/module/selectDateSheet.dart';
import 'package:callo/view/module/selectNowCourseListSheet.dart';
import 'package:callo/view/module/showCourseNumSheet.dart';

import 'logic.dart';

class CourseSetViewPage extends StatelessWidget {
  CourseSetViewPage({Key? key}) : super(key: key);
  final logic = Get.put(CourseSetViewLogic());
  final state = Get.find<CourseSetViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['backgroundColor'] as List ),
      appBar: AppBar(
        title: Text(
          '课表设置',
          style: TextStyle(fontSize: 20, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List ),),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
        iconTheme: IconThemeData(
            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['defaultIconColor'] as List )
        ),
      ),
      body: Obx(() => ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text(
              '课表设置',
              style: TextStyle(fontSize: 13, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '彩色课表',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '此选项可以将不同课程进行不同颜色的区分',
                            style: TextStyle(
                                fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                          Obx(() => Switch(
                              value: CourseData.isColorClassSchedule.value,
                              onChanged: (v) {
                                ShareDateUtil().setColorClassSchedule(v);
                              }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              ShareDateUtil().setColorClassSchedule(
                  !CourseData.isColorClassSchedule.value);
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '纯白背景/图片背景',
                              style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                            ),
                            Text(
                              '此选项可以调整课表背景图片',
                              style: TextStyle(
                                  fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          children: [
                            // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                            Obx(() => Switch(
                                value: CourseData.isPictureBackground.value,
                                onChanged: (v) {
                                  ShareDateUtil().setIsPictureBackground(v);
                                }))
                          ],
                        ),
                      )
                    ],
                  ),
                  Visibility(
                    child: Container(
                      height: 300,
                      child: Column(
                        children: [
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(35, 5, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '背景透明度   ${(CourseData.courseBackgroundOpacity.value * 100).toInt()}',
                                            style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Slider(
                                        value: CourseData
                                            .courseBackgroundOpacity.value,
                                        onChanged: (v) {
                                          // CourseData.courseBackgroundOpacity.value = double.parse(v.toStringAsFixed(3));
                                          ShareDateUtil()
                                              .setCourseBackgroundOpacity(
                                              double.parse(v
                                                  .toStringAsFixed(3)));
                                          // log(v.toString());
                                        })
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height: 40,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(35, 5, 0, 0),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '随机二次元背景图',
                                            style: TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                                          Obx(() => Transform.scale(
                                            scale: 0.7,
                                            child: Switch(
                                                value: CourseData
                                                    .isRandomQuadraticBackground
                                                    .value,
                                                onChanged: (v) {
                                                  ShareDateUtil()
                                                      .setIsRandomQuadraticBackground(
                                                      v);
                                                  if (v) {
                                                    ShareDateUtil()
                                                        .setIsUrlBackground(
                                                        false);
                                                    ShareDateUtil()
                                                        .setIsCustomerLocalBackground(
                                                        false);
                                                  }
                                                }),
                                          ))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height: 100,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              35, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '自定义图片URL背景图',
                                                style:
                                                TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                                              Obx(() => Transform.scale(
                                                scale: 0.7,
                                                child: Switch(
                                                    value: CourseData
                                                        .isUrlBackground
                                                        .value,
                                                    onChanged: (v) {
                                                      ShareDateUtil()
                                                          .setIsUrlBackground(
                                                          v);
                                                      if (v) {
                                                        ShareDateUtil()
                                                            .setIsRandomQuadraticBackground(
                                                            false);
                                                        ShareDateUtil()
                                                            .setIsCustomerLocalBackground(
                                                            false);
                                                      }
                                                    }),
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.fromLTRB(35, 0, 20, 0),
                                      child: TextField(
                                          controller:
                                          logic.backGroundUrlController,
                                          decoration: InputDecoration(
                                            label: Text('URL',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),
                                            hintText: '请输入图片URL链接',
                                            hintStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )),
                                            contentPadding:
                                            EdgeInsets.fromLTRB(
                                                10, 0, 10, 0),
                                            enabledBorder:
                                            OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        0))),
                                            focusedBorder:
                                            OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.all(
                                                    Radius.circular(
                                                        0))),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                          InkWell(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Container(
                                height: 100,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              35, 5, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '自定义背景图',
                                                style:
                                                TextStyle(fontSize: 15,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                              0, 0, 10, 0),
                                          child: Row(
                                            children: [
                                              // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                                              Obx(() => Transform.scale(
                                                scale: 0.7,
                                                child: Switch(
                                                    value: CourseData
                                                        .isCustomerLocalBackground
                                                        .value,
                                                    onChanged: (v) {
                                                      ShareDateUtil()
                                                          .setIsCustomerLocalBackground(
                                                          v);
                                                      if (v) {
                                                        ShareDateUtil()
                                                            .setIsUrlBackground(
                                                            false);
                                                        ShareDateUtil()
                                                            .setIsRandomQuadraticBackground(
                                                            false);
                                                      }
                                                    }),
                                              ))
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: 35,
                                      width: MediaQuery.of(Get.context!)
                                          .size
                                          .width,
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            35, 0, 35, 0),
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ))
                                            ),
                                            onPressed: () async {
                                              await logic.getImage();
                                            },
                                            child: Text('选择图片',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    visible: CourseData.isPictureBackground.value,
                  )
                ],
              ),
            ),
            onTap: () {},
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '摇一摇返回当前周',
                              style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                            ),
                            Text(
                              '此选项可以在浏览其他周课表时摇一摇手机快速移动到当前周课表',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 10,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                          Obx(() => Switch(
                              value: CourseData.isShakeToNowSchedule.value,
                              onChanged: (v) {
                                ShareDateUtil().setShakeToNowSchedule(v);
                              }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              ShareDateUtil().setShakeToNowSchedule(
                  !CourseData.isShakeToNowSchedule.value);
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 65,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Container(
                        width: 250,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '午休分割线',
                              style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                            ),
                            Text(
                              '是否显示课表午休分割线',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 10,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                          Obx(() => Switch(
                              value: CourseData.isNoonLineSwitch.value,
                              onChanged: (v) {
                                ShareDateUtil().setNoonLineSwitch(v);
                              }))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              ShareDateUtil().setShakeToNowSchedule(
                  !CourseData.isShakeToNowSchedule.value);
            },
          ),
          // InkWell(
          //   child: Padding(
          //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          //     child: Container(
          //       height: 65,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Padding(
          //             padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
          //             child: Container(
          //               width: 250,
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Text(
          //                     '采用最新课表爬虫算法',
          //                     style: TextStyle(fontSize: 20),
          //                   ),
          //                   Text(
          //                     '默认开启最新爬虫算法，一般情况也推荐使用最新',
          //                     maxLines: 2,
          //                     style: TextStyle(
          //                         fontSize: 10, color: Colors.black45),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //           Padding(
          //             padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          //             child: Row(
          //               children: [
          //                 // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
          //                 Obx(() => Switch(
          //                     value: CourseData.newOrOldCourseScheduleChoose.value,
          //                     onChanged: (v) {
          //                       ShareDateUtil().setNewOrOldCourseScheduleChoose(v);
          //                     }))
          //               ],
          //             ),
          //           )
          //         ],
          //       ),
          //     ),
          //   ),
          //   onTap: () {
          //     ShareDateUtil().setNewOrOldCourseScheduleChoose(
          //         !CourseData.newOrOldCourseScheduleChoose.value);
          //   },
          // ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '学期课表',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '此项为必选，会根据官网拉取最新的课表数据',
                            style: TextStyle(
                                fontSize: 10,
                                // color: Colors.black45
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text(
                              '${CourseData.nowCourseList.value}',
                              style: TextStyle(
                                  fontSize: 14,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/end.png',
                            height: 17,
                            width: 17,
                            // color: Colors.black45,
                            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              //用于选择开学年月日
              selectNowCourseListSheet(context).show().then((value) async {
                if (value != null) {
                  Get.snackbar(
                    "课表通知",
                    "正在切换课表...",
                    duration: Duration(milliseconds: 1500),
                  );
                  CourseData.nowCourseList.value = value;
                  ShareDateUtil().setNowCourseList(value);
                  await logic.onRefresh();
                  Get.snackbar(
                    "课表通知",
                    "课表切换成功",
                    duration: Duration(milliseconds: 1500),
                  );
                  // CourseUtil()
                  //     .getAllCourseWeekList("${CourseData.nowCourseList}")
                  //     .then((value) {
                  //   Get.snackbar(
                  //     "课表通知",
                  //     "课表切换成功",
                  //     duration: Duration(milliseconds: 1500),
                  //   );
                  // });
                }
              });
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '开学时间',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '判断是否为假期中以及自动判断周数',
                            style: TextStyle(
                                fontSize: 10,
                                // color: Colors.black45
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text(
                              '${CourseData.schoolOpenTime.value}',
                              style: TextStyle(
                                  fontSize: 14,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/end.png',
                            height: 17,
                            width: 17,
                            // color: Colors.black45,
                            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              //用于选择开学年月日
              selectDateSheet(context).show().then((value) {
                if (value != null) {
                  CourseData.schoolOpenTime.value = value;
                  CourseData.nowWeek.value = CourseUtil.getNowWeek(
                      CourseData.schoolOpenTime.value,
                      CourseData.ansWeek.value);
                  ShareDateUtil()
                      .setSchoolOpenDate(CourseData.schoolOpenTime.value)
                      .then((value) {
                    // course_listState?.refreshAllCourseTable();
                  }); //记录本地存储
                }
              });
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '当前周数',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '开学到现在第几周',
                            style: TextStyle(
                                fontSize: 10,
                                // color: Colors.black45
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text(
                              '${CourseData.nowWeek.value == 0 ? '假期中' : CourseData.nowWeek.value}',
                              style: TextStyle(
                                  fontSize: 14,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/end.png',
                            height: 17,
                            width: 17,
                            // color: Colors.black45,
                            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              Get.snackbar(
                "课表通知",
                "${CourseData.nowWeek.value == 0 ? "假期中" : '当前第${CourseData.nowWeek.value}周'}",
                duration: Duration(milliseconds: 1500),
              );
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '本学期总周数',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '请选择本学期总共多少周',
                            style: TextStyle(
                                fontSize: 10,
                                // color: Colors.black45
                                color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text(
                              '${CourseData.ansWeek.value}',
                              style: TextStyle(
                                  fontSize: 14,
                                  // color: Colors.black45
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                              ),
                            ),
                          ),
                          Image.asset(
                            'assets/images/end.png',
                            height: 17,
                            width: 17,
                            // color: Colors.black45,
                            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () async {
              showCourseNumSheet(context).show().then((value) {
                if (value != null) {
                  CourseData.ansWeek.value = value;
                  ShareDateUtil()
                      .setSemesterWeekNum(CourseData.ansWeek.value);
                  // ToastUtil.show('正在刷新课表...');
                  // course_listState?.updatePullDataAndRefresh().then((value){
                  //   ToastUtil.show('刷新成功');
                  // });
                }
              });
            },
          ),
          CourseData.newOrOldCourseScheduleChoose.value
              ? InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  height: 650,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '各小节课时间',
                                  style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),
                                ),
                                Text(
                                  '调节每小节课的起止时间',
                                  style: TextStyle(
                                      fontSize: 10,
                                      // color: Colors.black45
                                      color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )
                                  ),
                                ),
                                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
                                  height: 40,
                                  width: MediaQuery.of(context).size.width*0.8,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.red)
                                      ),
                                      onPressed: (){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MediaQuery(data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0), child: AlertDialog(
                                              backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['backgroundColor'] as List ),
                                              title: Text("提示",style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),
                                              content: Text("确定重置吗？",style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("取消"),
                                                ),
                                                TextButton(onPressed: () {
                                                  ShareDateUtil().setCourseTimeList(CourseData.defaultCourseTime).then((value) => CourseData.courseTime.refresh());
                                                  Navigator.of(context).pop();
                                                }, child: const Text("确定")),
                                              ],
                                            ));
                                          },
                                        );
                                      }, child: Text('一键重置默认时间',style: TextStyle(color:Colors.black45),)),
                                ),)
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/end.png',
                                  height: 17,
                                  width: 17,
                                  // color: Colors.black45,
                                  color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['foregroundColor'] as List ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: CourseData.courseTime
                            .map(
                              (element) => Padding(
                            padding: EdgeInsets.fromLTRB(
                                20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第${state.courseCount.value >= 12 ? state.courseCount.value = 1 : ++state.courseCount.value}小节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )),
                                ),
                                Text(
                                  '${CourseData.courseTime.value[state.courseCount.value - 1]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['hintTextColor'] as List )),
                                )
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      )
                    ],
                  )),
            ),
            onTap: () async {
              //调节时间
              await selectCourseTimeSheet
                  .show(Get.context!, 12, CourseData.courseTime.value)
                  .then((resDataTime) async {
                if (resDataTime != null) {
                  List<String> resTime = [];
                  //用于刷新控件
                  for (int i = 1;
                  i <= CourseData.courseTime.value.length;
                  ++i) {
                    resTime.add(
                        '${(resDataTime[i * 2 - 2].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 2].minute.toString()).padLeft(2, '0')}-${(resDataTime[i * 2 - 1].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 1].minute.toString()).padLeft(2, '0')}');
                    // CourseData.oldCourseTime.value[i-1] = '${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}';
                  }
                  //用于刷新课表的时间显示控件
                  await ShareDateUtil()
                      .setCourseTimeList(resTime)
                      .then((value) {
                    Get.snackbar(
                      "课表通知",
                      "修改成功",
                      duration: Duration(milliseconds: 1500),
                    );
                  });
                }
              });
            },
          )
              : InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '各大节课时间',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  '调节每大节课的起止时间',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/end.png',
                                  height: 17,
                                  width: 17,
                                  color: Colors.black45,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第一大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[0]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第二大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[1]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第三大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[2]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第四大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[3]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第五大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[4]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '第六大节',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                ),
                                Text(
                                  '${CourseData.oldCourseTime.value[5]}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black45),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )),
            ),
            onTap: () async {
              //调节时间

              await selectBeginCourseTimeSheet(context)
                  .show()
                  .then((resDataTime) async {
                if (resDataTime != null) {
                  List<String> resTime = [];
                  //用于刷新控件
                  for (int i = 1;
                  i <= CourseData.oldCourseTime.value.length;
                  ++i) {
                    resTime.add(
                        '${(resDataTime[i * 2 - 2].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 2].minute.toString()).padLeft(2, '0')}-${(resDataTime[i * 2 - 1].hour.toString()).padLeft(2, '0')}:${(resDataTime[i * 2 - 1].minute.toString()).padLeft(2, '0')}');
                    // CourseData.oldCourseTime.value[i-1] = '${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}';
                  }
                  //用于刷新课表的时间显示控件
                  await ShareDateUtil()
                      .setOldCourseTimeList(resTime)
                      .then((value) {
                    Get.snackbar(
                      "课表通知",
                      "修改成功",
                      duration: Duration(milliseconds: 1500),
                    );
                  });
                }
              });
            },
          )
        ],
      )),
    ));
  }
}
