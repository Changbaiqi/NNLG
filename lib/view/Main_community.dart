import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CusBehavior.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/Chitchat.dart';

class Main_community extends StatefulWidget {
  const Main_community({Key? key}) : super(key: key);

  @override
  State<Main_community> createState() => _Main_communityState();
}

class _Main_communityState extends State<Main_community> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Community(),
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
          height: 250,
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
            height: 95,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ScrollConfiguration(
                behavior: CusBehavior(),
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  children: [
                    InkWell(
                      child: boxChildSvg("images/lyl.svg", '聊一聊'),
                      onTap: () {
                        // ToastUtil.show('该功能未开放');
                        Navigator.of(context).push(MaterialPageRoute(builder: (builder){ return Chitchat();}));
                      },
                    ),
                    InkWell(
                      child: boxChildImg('images/NNLG.png', '培养计划'),
                      onTap: () {
                        ToastUtil.show('该功能未开放');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
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
