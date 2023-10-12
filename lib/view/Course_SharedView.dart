import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/view/Main.dart';

class Course_SharedView extends StatefulWidget {
  const Course_SharedView({Key? key}) : super(key: key);

  @override
  State<Course_SharedView> createState() => _Course_SharedViewState();
}

class _Course_SharedViewState extends State<Course_SharedView> {

  int? _shareCount;
  List cc=[
    '{"name": "张三","id": "21060231"}',
    '{"name": "李四","id": "21060231"}',
    '{"name": "王五","id": "21060231"}'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('查看'),
          elevation: 0,
        ),
        body:   ListView.separated(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return childView(cc, index);
          },
          itemCount:3,
          separatorBuilder: (BuildContext context, int index) =>
              Divider(height: 0.01,indent: 10,endIndent: 10,thickness: 0.1, color: Colors.black),
        ));
  }

  /**
   * 每个选项的子项
   */
  Widget childView(List list,int index) {
    var json = jsonDecode(list[index]);
    return Container(
      height: 50,
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
            Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('姓名：${json['name']}'),
                Text('学号：${json['id']}')
              ],
            ),)
          ],
        ),
      ),
    );
  }
}
