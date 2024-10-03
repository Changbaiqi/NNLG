import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/CustomerThemeUtil.dart';
import 'package:nnlg/view/main_community_view/view.dart';
import 'package:nnlg/view/main_course_view/view.dart';
import 'package:nnlg/view/main_user_view/view.dart';
import 'package:nnlg/view/main_water_view/view.dart';
import 'package:nnlg/view/nnlg_community_view/view.dart';

import '../../dao/CustomThemeData.dart';
import 'logic.dart';

class MainViewPage extends StatelessWidget {
  MainViewPage({Key? key}) : super(key: key);
  final logic = Get.find<MainViewLogic>();
  final state = Get
      .find<MainViewLogic>()
      .state;

  List<Widget> _viewList = [
    MainCommunityViewPage(),
    MainWaterViewPage(),
    MainCourseViewPage(),
    NnlgCommunityViewPage(),
    MainUserViewPage(),
    // CourseSetViewPage(),
  ];

  List<BottomNavigationBarItem> _itemList = [
    BottomNavigationBarItem(icon: Icon(Icons.bakery_dining), label: '社区'),
    BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: '打水'),
    BottomNavigationBarItem(icon: Icon(Icons.discord),label: '社区'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: '账户'),
    // BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,

      body: PageView(
        children: _viewList,
        controller: state.pageController.value,
        onPageChanged: (indexPage) {
          state.index.value = indexPage;
        },),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(() =>
          FloatingActionButton(
            child: Icon(Icons.calendar_month,color: Colors.black,),
            backgroundColor: state.index.value == 2 ? CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['selectColor']as List): CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['nonSelectColor']as List),
            onPressed: () {
              state.pageController.value.animateToPage(
                  2, duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
              state.index.value = 2;
            },
          )),
      bottomNavigationBar: Obx(() =>
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(500)),
                  // color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_view/bottomTableBackground']!['color'] as List, Colors.white),
                  color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['backgroundColor']as List),
                  image: (CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['backgroundImage']!=null?DecorationImage(image: AssetImage((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['backgroundImage']),fit: BoxFit.cover):null,
                  boxShadow: [
                    BoxShadow(
                        // color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_view/bottomTableBackground']!['color'] as List),
                        color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['backgroundColor'] as List),
                        blurRadius: 100,
                        spreadRadius: 1,
                        offset: Offset(0, 40))
                  ]),
              child: BottomAppBar(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                height: 70,
                elevation: 0,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                      logic.animationJumpToPage(0);
                    },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.bakery_dining, color: state.index.value ==
                              0
                              ? CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['selectColor']as List)
                              : CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['nonSelectColor']as List),),
                          Text('主页', style: TextStyle(fontSize: 12,color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['textColor']as List),),),
                        ],
                      ),
                      splashRadius: 27,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),
                    IconButton(onPressed: () {
                      logic.animationJumpToPage(1);
                    },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.water_drop, color: state.index.value == 1
                              ? CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['selectColor']as List)
                              : CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['nonSelectColor']as List),),
                          Text('打水', style: TextStyle(fontSize: 12,color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['textColor']as List)),),
                        ],
                      ),
                      splashRadius: 27,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),
                    Container(
                      width: 25,
                      height: 0,
                    ),
                    IconButton(onPressed: () {
                      logic.animationJumpToPage(3);
                    },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.discord, color: state.index.value == 3
                              ? CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['selectColor']as List)
                              : CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['nonSelectColor']as List),),
                          Text('社区', style: TextStyle(fontSize: 12,color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['textColor']as List)),),
                        ],
                      ),
                      splashRadius: 27,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),),
                    IconButton(onPressed: () {
                      logic.animationJumpToPage(4);
                    },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: state.index.value == 4
                              ? CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['selectColor']as List)
                              : CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['nonSelectColor']as List),),
                          Text('我的', style: TextStyle(fontSize: 12,color: CustomerThemeUtil.setColor((CustomThemeData.nowThemeData.value['main_view']!['bottomNavigate']!as LinkedHashMap)['textColor']as List)),),
                        ],
                      ),
                      splashRadius: 27,
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),)
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
