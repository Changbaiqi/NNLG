import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class CourseSharedChooseViewPage extends StatelessWidget {
  CourseSharedChooseViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedChooseViewLogic>();
  final state = Get.find<CourseSharedChooseViewLogic>().state;

  int? _shareCount;
  List cc = [
    '{"name": "张三","id": "21060231"}',
    '{"name": "李四","id": "21060231"}',
    '{"name": "王五","id": "21060231"}'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('查询'),
          elevation: 0,
        ),
        body: Obx(() => ListView.separated(
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return childView(state.accountList.value[index]);
              },
              itemCount: state.accountList.value.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                  height: 0.01,
                  indent: 10,
                  endIndent: 10,
                  thickness: 0.1,
                  color: Colors.black),
            )));
  }

  /**
   * 每个选项的子项
   */
  Widget childView(ShareAccountList accountList) {
    // var json = jsonDecode(list[index]);
    return InkWell(
      child: Container(
        height: 90,
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('姓名：${accountList.studentName}'),
                    Text('班级:${accountList.studentClass}'),
                    Text('学号：${accountList.userAccount}')
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: (){
        Get.toNamed(Routes.CourseSharedShow,arguments: {'data': accountList});
      },
    );
  }
}
