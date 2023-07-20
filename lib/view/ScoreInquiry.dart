import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/utils/CourseScoreUtil.dart';

class ScoreInquiry extends StatefulWidget {
  const ScoreInquiry({Key? key}) : super(key: key);

  @override
  State<ScoreInquiry> createState() => _ScoreInquiryState();
}

class _ScoreInquiryState extends State<ScoreInquiry> {
  List<String> _searList = [];
  String? _selectTime = '全部学期'; //栋号选择
  List<String> _scoreList = []; //分数list
  Widget _showScoreWidget = Table();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            DropdownButton<String>(
                value: _selectTime,
                items: _searList
                    .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(e),
                        )))
                    .toList(),
                onChanged: (value) {
                  _selectTime = value;
                  _showScoreList(_selectTime ?? "");
                  setState(() {});
                })
          ],
        ),
      ),
      body: ListView(
        children: [_showScoreWidget],
      ),
    );
  }

  @override
  void initState() {
    _initSearchList();
    _showScoreList(this._selectTime ?? "全部学期");
  }

  //初始化列表
  _initSearchList() {
    CourseScoreUtil().getReportCardQueryList().then((value) {
      this._searList = value;
      setState(() {});
    });
  }

  //通过日期选择相关成绩展示
  _showScoreList(String time) async {
    if (time == '全部学期') time = '';
    await CourseScoreUtil().getScoreList(time).then((value) {
      this._scoreList = value;
      //print(value);
    });
    List<TableRow> widgets = [
      TableRow(children: [
        Text(
          '课程编号',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '课程名称',
          style: TextStyle(fontSize: 20),
        ),
        Text(
          '分数',
          style: TextStyle(fontSize: 20),
        ),
      ])
    ];
    for (String strJson in this._scoreList) {
      var json = jsonDecode(strJson);
      widgets.add(TableRow(children: [
        Center(
          child: Text(json['courseNumber']),
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['courseName'])],
        ),
        Center(
          child: Text(json['courseScore'],style: TextStyle(color: scoreColors(json['courseScore']),),
        )
      )]));
    }
    Table table = Table(
      border: TableBorder.all(color: Colors.black),
      children: widgets,
    );
    this._showScoreWidget = table;
    setState(() {});
  }


  //成绩颜色判断
 Color scoreColors(String score){
    double? num = double.tryParse(score);
    if(num==null){
      if(score=='不合格')
        return Colors.red;
      if(score=='合格')
        return Colors.amber;
      if(score=='优')
        return Colors.deepPurple;
      return Colors.black;
    }
    if(num!<60)
      return Colors.red;
    if(num==60)
      return Colors.amber;
    if(num>90)
      return Colors.deepPurple;

    return Colors.black;
 }
}
