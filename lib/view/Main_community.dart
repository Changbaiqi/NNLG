import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CourseScoreUtil.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/CusBehavior.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/Chitchat.dart';
import 'package:nnlg/view/ExamInquiry.dart';
import 'package:nnlg/view/Main.dart';
import 'package:nnlg/view/ScoreInquiry.dart';
import 'package:nnlg/view/module/showBindPowerDialog.dart';

import '../dao/LoginData.dart';
import '../utils/MainUserUtil.dart';

class Main_community extends StatefulWidget {
  const Main_community({Key? key}) : super(key: key);

  @override
  State<Main_community> createState() => _Main_communityState();
}

class _Main_communityState extends State<Main_community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [Community()],
      ),
    );
  }
}

class Community extends StatefulWidget {
  const Community({Key? key}) : super(key: key);

  @override
  State<Community> createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
  int onClickTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                        ValueListenableBuilder<int>(
                          valueListenable: ContextDate.onLineTotalCount,
                          builder:
                              (BuildContext context, int value, Widget? child) {
                            return Text('${value}',
                                style: TextStyle(fontSize: 30));
                          },
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('软件点击量'),
                        Text(
                          '${onClickTotal}',
                          style: TextStyle(fontSize: 30),
                        )
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
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0)
                    ,child: InkWell(
                      child: boxChildSvg("assets/images/lyl.svg", '校园聊一聊'),
                      onTap: () {
                        // ToastUtil.show('该功能未开放');
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return Chitchat();
                        }));
                      },
                    ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: InkWell(
                    child: boxChildImg("assets/images/NNLG.png", '考试安排'),
                    onTap: () {
                      // ToastUtil.show('该功能未开放');
                      Navigator.of(context).push(MaterialPageRoute(builder: (builder){ return ExamInquiry();}));
                    },
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: InkWell(
                    child: boxChildImg('assets/images/NNLG.png', '宿舍电费预警'),
                    onTap: () async {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return Center(
                              child: showBindPowerDialog(),
                            );
                          });



                      //Navigator.of(context).push(MaterialPageRoute(builder: (builder){return SearchPower();}));
                    },
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: InkWell(
                    child: boxChildImg('assets/images/NNLG.png', '培养计划'),
                    onTap: () {
                      ToastUtil.show('该功能未开放');
                    },
                  ),),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 0),child: InkWell(
                    child: boxChildImg('assets/images/NNLG.png', '成绩查询'),
                    onTap: () {
                      CourseScoreUtil().getReportCardQueryList().then((value){
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                          return ScoreInquiry();
                        }));
                      });
                    },
                  ),),
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
            child: Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('卡号：'+"1231231"),
                    Text('蒋林志')
                  ],
                ),),
                Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),child: Text('￥ 10.0',style: TextStyle(fontSize: 35),),),
                Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Column(
                  children: [
                    Text('宿舍状态',style: TextStyle(fontSize: 20),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('绑定宿舍：'),
                        Text('8403'),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('宿舍电费剩余：'),
                        Text('40￥'),
                      ],),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('预警金额：'),
                        Text('20￥')
                      ],),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(onPressed: (){}, child: Text('消息卡片设置'),style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blueGrey)),),
                    )
                  ],
                ),)
              ],
            ),
          ),
        ),
        Container(
          height: 40,
        )
      ],
    );
  }

  /**
   * svg网格布局子组件
   */
  Widget boxChildSvg(String imgFile, String label) {
    return Center(
      child: Column(
        children: [
          SvgPicture.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }

  /**
   * img网格布局子组件
   */
  Widget boxChildImg(String imgFile, String label) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }

  /**
   * 用于初始化显示软件打开次数
   */
  getOnClickTotal() {
    AccountUtil().getOnclickTotal().then((value) {
      if (value['code'] == 200) {
        setState(() {
          onClickTotal = value['msg'];
        });
      }
    });
  }

  @override
  void initState() {
    getOnClickTotal();
  }
}
