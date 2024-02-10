import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/CourseScoreUtil.dart';
import 'package:nnlg/utils/CusBehavior.dart';
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
          Column(
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
                                    value: ContextDate.onLineTotalCount.value
                                        .toInt(),
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
                  height: 170,
                  child: ScrollConfiguration(
                    behavior: CusBehavior(),
                    child: GridView(
                      padding: EdgeInsets.symmetric(vertical: 0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildSvg(
                                "assets/images/lyl.svg", '校园聊一聊'),
                            onTap: () {
                              Get.toNamed(Routes.ChitChat);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildImg(
                                "assets/images/NNLG.png", '考试安排'),
                            onTap: () {
                              Get.toNamed(Routes.ExamInquiry);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildImg(
                                'assets/images/NNLG.png', '宿舍电费预警'),
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
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildImg(
                                'assets/images/NNLG.png', '培养计划'),
                            onTap: () {
                              // Get.snackbar("通知", "该功能未开放",duration: Duration(milliseconds: 1500),);
                              Get.toNamed(Routes.TrainPlan);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildImg(
                                'assets/images/NNLG.png', '成绩查询'),
                            onTap: () {
                              CourseScoreUtil()
                                  .getReportCardQueryList()
                                  .then((value) {
                                Get.toNamed(Routes.ScoreInquiry);
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: InkWell(
                            child: logic.boxChildImg(
                                'assets/images/NNLG.png', '教学评价'),
                            onTap: () {
                              CourseScoreUtil()
                                  .getReportCardQueryList()
                                  .then((value) {
                                Get.toNamed(Routes.TeachingEva);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
                  height: 260,
                  width: MediaQuery.of(context).size.width,
                  child: noJustMessengerCard(),
                ),
              ),
              Container(
                height: 40,
              )
            ],
          )
        ],
      ),
    );
  }

  /**
   * 绑定过后的一信通信息卡片
   */
  bindingJustMessengerCard() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('卡号：' + "1231231"),
              Text('蒋林志'),
              Container(
                width: 60,
                height: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(logic.context!)
                        .push(MaterialPageRoute(builder: (builder) {
                      return SchoolCardInformSet();
                    }));
                  },
                  child: Text(
                    '设置',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Text(
            '￥ 10.0',
            style: TextStyle(fontSize: 35),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            children: [
              Text(
                '宿舍状态',
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('绑定宿舍：'),
                  Text('8403'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('宿舍电费：'),
                  Text('40￥'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('预警金额：'), Text('20￥')],
              ),
              Container(
                width: MediaQuery.of(logic.context!).size.width,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('刷新卡片信息'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /**
   * 没绑定时候的一信通卡片信息
   */
  noJustMessengerCard() {
    return Center(
      child: ElevatedButton(
        child: Text('绑定'),
        onPressed: () {
          JustMessengerUtil()
              .LoginPost('abc020731', '18378099595')
              .then((value) {
            // print(value);
            if (value['resultCode'] != null) {
              Get.snackbar('提示', value['message'],
                  duration: Duration(milliseconds: 1500));
              return;
            }
            //装置token等参数
            AccountData.justMessengerAccess_Token.value = value['access_token'];
            AccountData.justMessengerRefresh_Toekn.value =
                value['refresh_token'];
            AccountData.justMessengerSchoolId.value = value['schoolId'];
            AccountData.justMessengerCompany.value = value['company'];
            AccountData.justMessengerExpires_in.value = value['expires_in'];
            AccountData.justMessengerToken_Type.value = value['token_type'];
            AccountData.justMessengerJti.value = value['jti'];
          });
        },
      ),
    );
  }
}
