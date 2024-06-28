/* FileName ClassScheduleWidget
 *
 * @Author 20840
 * @Date 2024/6/20 10:17
 *
 * @Description TODO 单个课表组件，用于渲染单个课表的显示的
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassScheduleWidget extends StatelessWidget{

   final courseJson; //课程信息的json

  static final _weekViewKey = GlobalKey();

  ClassScheduleWidget({this.courseJson});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          key: _weekViewKey,
          height: 50,
          child: Row(
            children: [
              Expanded(child: Container(child: Text(''),)),
              Expanded(child: Container(child: Text('周一'),)),
              Expanded(child: Container(child: Text('周二'),)),
              Expanded(child: Container(child: Text('周三'),)),
              Expanded(child: Container(child: Text('周四'),)),
              Expanded(child: Container(child: Text('周五'),)),
              Expanded(child: Container(child: Text('周六'),)),
              Expanded(child: Container(child: Text('周日'),))
            ],
          ),
        ),
        Expanded(child: MediaQuery.removePadding(context: context,removeTop: true, child: ListView(
          children: [
            
          ],
        )),flex: 1,)
      ],
    );
  }
}