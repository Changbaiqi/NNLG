import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/CourseScoreUtil.dart';
import 'package:nnlg/utils/JustMessengerUtil.dart';
import 'package:nnlg/view/SchoolCardInformSet.dart';
import 'package:nnlg/view/module/showBindPowerDialog.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class MainCommunityViewPage extends StatelessWidget {
  MainCommunityViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainCommunityViewLogic());
  final state = Get.find<MainCommunityViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Scaffold(
      body: ListView(
        children: [
          //头部显示--------------------
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, 7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color: Color(0xFFdfdfdf))
                ]),
            height: 100,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('在线人数'),
                          Obx(() => AnimatedFlipCounter(
                                value:
                                    ContextDate.onLineTotalCount.value.toInt(),
                                textStyle: TextStyle(fontSize: 30),
                              ))
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('软件点击量'),
                          Obx(() => AnimatedFlipCounter(
                                value: state.onClickTotal.value.toInt(),
                                textStyle: TextStyle(fontSize: 30),
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          //其他功能
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.0, 7.0),
                        blurRadius: 14.0,
                        spreadRadius: 0,
                        color: Color(0xFFdfdfdf))
                  ]),
              // height: 170,
              child: GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                childAspectRatio: 1.2,
                children: [
                  InkWell(
                    child: logic.boxChildLottie('assets/images/chat_room_lottie.json', '校园聊一聊'),
                    // child: logic.boxChildSvg("assets/images/lyl.svg", '校园聊一聊'),
                    onTap: () {
                      Get.toNamed(Routes.ChitChat);
                    },
                  ),
                  InkWell(
                    child: logic.boxChildLottie('assets/images/exam_plan_lottie.json', '考试安排'),
                    // child: logic.boxChildSvg(
                    //     "assets/images/exam_plan.svg", '考试安排'),
                    onTap: () {
                      Get.toNamed(Routes.ExamInquiry);
                    },
                  ),
                  InkWell(
                    child:
                        logic.boxChildSvg('assets/images/dorm.svg', '宿舍电费预警'),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return Center(
                              child: showBindPowerDialog(),
                            );
                          });
                    },
                  ),
                  InkWell(
                    child: logic.boxChildSvg(
                        'assets/images/train_plan.svg', '培养计划'),
                    onTap: () {
                      // Get.snackbar("通知", "该功能未开放",duration: Duration(milliseconds: 1500),);
                      Get.toNamed(Routes.TrainPlan);
                    },
                  ),
                  InkWell(
                    child: logic.boxChildLottie('assets/images/score_search_lottie.json', '成绩查询'),
                    // child: logic.boxChildSvg(
                    //     'assets/images/score_inquiry2.svg', '成绩查询'),
                    onTap: () {
                      CourseScoreUtil().getReportCardQueryList().then((value) {
                        Get.toNamed(Routes.ScoreInquiry);
                      });
                    },
                  ),
                  InkWell(
                    child: logic.boxChildLottie('assets/images/evaluate_lottie.json', '教学评价'),
                    // child: logic.boxChildSvg(
                    //     'assets/images/teach_eval.svg', '教学评价'),
                    onTap: () {
                      CourseScoreUtil().getReportCardQueryList().then((value) {
                        Get.toNamed(Routes.TeachingEva);
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          //校园卡信息
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(0.0, 7.0),
                        blurRadius: 14.0,
                        spreadRadius: 0,
                        color: Color(0xFFdfdfdf))
                  ]),
              // height: 260,
              width: MediaQuery.of(context).size.width,
              child: Obx(() => state.isLoginJustMessenger.value?logic.bindingJustMessengerCard():logic.noJustMessengerCard()),
            ),
          ),
          Container(
            height: 40,
          )
        ],
      ),
    );
  }



}
