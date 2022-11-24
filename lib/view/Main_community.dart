import 'dart:io';

import 'package:flutter/material.dart';

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
                        Text('1',style: TextStyle(fontSize: 30))
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('软件点击量'),
                        Text('1',style: TextStyle(fontSize: 30),)
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
            height: 80,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: ScrollConfiguration(
                behavior: CusBehavior(),
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  children: [
                    boxChild("images/lyl.svg", '聊一聊'),
                    boxChild('images/NNLG.png', '学期计划')
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }



  Widget boxChild(String imgFile, String label) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            imgFile,
            height: 40,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 13),
          )
        ],
      ),
    );
  }
}

class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildViewportChrome(context, child, axisDirection);
  }
}
