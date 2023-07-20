import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/utils/ExamInquiryUtil.dart';

import '../utils/CourseScoreUtil.dart';

class ExamInquiry extends StatefulWidget {
  const ExamInquiry({Key? key}) : super(key: key);

  @override
  State<ExamInquiry> createState() => _ExamInquiryState();
}

class _ExamInquiryState extends State<ExamInquiry> {
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
    ExamInquiryUtil().getExamNowSelectTime().then((value) async {
      _selectTime = value;
      await ExamInquiryUtil().getExamList(_selectTime??"");
      _showScoreList(this._selectTime ?? "全部学期");
      setState(() {});
    });

  }

  //初始化列表
  _initSearchList() {
    ExamInquiryUtil().getReportCardQueryList().then((value) {
      //print(value.toString());
      this._searList = value;
      setState(() {});
    });
  }

  //通过日期选择相关成绩展示
  _showScoreList(String time) async {
    if (time == '全部学期') time = '';
    await ExamInquiryUtil().getExamList(time).then((value) {
      this._scoreList = value;
      //print(value);
    });

    List<TableRow> widgets = [
      TableRow(children: [
        Text(
          '序号',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '考试场次',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '课程编号',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '课程名称',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '考试时间',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '考场',
          style: TextStyle(fontSize: 12),
        ),
        Text(
          '座位号',
          style: TextStyle(fontSize: 12),
        ),
      ])
    ];
    for (String strJson in this._scoreList) {
      var json = jsonDecode(strJson);
      widgets.add(TableRow(children: [
        Center(
          child: Text(json['number'],style: TextStyle(fontSize: 10),),
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['session'],style: TextStyle(fontSize: 10),)],
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['courseNumber'],style: TextStyle(fontSize: 10),)],
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['courseName'],style: TextStyle(fontSize: 10),)],
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['examTime'],style: TextStyle(fontSize: 10),)],
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['examRoom'],style: TextStyle(fontSize: 10),)],
        ),
        Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(json['seatNumber'],style: TextStyle(fontSize: 10),)],
        )
      ]));
    }
    Table table = Table(
      border: TableBorder.all(color: Colors.black),
      children: widgets,
      columnWidths: {
        0: FixedColumnWidth(25),
        1: FixedColumnWidth(55),
        2: FixedColumnWidth(55),
        5: FixedColumnWidth(75),
        6: IntrinsicColumnWidth()
      },
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
