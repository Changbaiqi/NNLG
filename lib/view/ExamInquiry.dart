import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
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



  var _mfuture;

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 30) / 2;
    var itemHeight = 255.0;
    var childAspectRatio = itemWidth / itemHeight;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('考试安排'),
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
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder(
        future: _mfuture,
        builder: (context, snapshot) {
          var widget;
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              widget = Text('出错了');
            } else {
              widget = ListView(
                children: [
                  /*_showScoreWidget,*/ Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: GridView.builder(
                          shrinkWrap: true,
                          itemCount: _scoreList.length,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemBuilder: (context, index) {
                            return _showchildElement(_scoreList[index]);
                          },
                        ),
                      ),
                      //_showchildElement("json")
                    ],
                  )
                ],
              );
            }
          } else {
            widget = Center(
              child: Lottie.asset('assets/images/loading.json',height: 200,width: 200),
            );
          }
          return Container(
            child: widget,
          );
        },
      ),
    );
  }

  @override
  void initState() {
    _initSearchList();
    ExamInquiryUtil().getExamNowSelectTime().then((value) async {
      _selectTime = value;
      // await ExamInquiryUtil().getExamList(_selectTime??"");
      // _showScoreList(this._selectTime ?? "全部学期");
      // setState(() {});

      _mfuture =_future();
    });


  }

  _future() async {
    // await ExamInquiryUtil().getExamNowSelectTime().then((value) async {
    //   _selectTime = value;
    //   await ExamInquiryUtil().getExamList(_selectTime??"");
    //   _showScoreList(this._selectTime ?? "全部学期");
    //   setState(() {});
    // });
    await _showScoreList(this._selectTime ?? "全部学期");
    return "";
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
    setState(() {});
  }

  /**
   * 单个组件
   */
  _showchildElement(json){
    int colorR = 0;
    int colorG = 0;
    int colorB = 0;
    while(true){
      colorR =Random().nextInt(255);
      colorG =Random().nextInt(255);
      colorB =Random().nextInt(255);
      if((colorR-colorG).abs()>=40 || (colorG-colorB).abs()>=40)
        break;
    }

    //print(json);
    json = jsonDecode(json);
    //var jsson = jsonDecode('{"name":"cc"}');
    return Container(
      height: 220,
      width: 150,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, colorR, colorG, colorB),
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 10,
            offset: Offset(1, 1)
          )
        ]
      ),
      child: Stack(
          children: [
            Positioned(child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(500))
              ),
              child: Center(
                child: Text('${json["number"]}',style: TextStyle(fontSize: 18,color: Colors.black87),),
              ),
            ),left: 10,top: 10,),
            Positioned(child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('科目：',style: TextStyle(fontSize: 15),),
                Container(
                  width: 100,
                  child: Text('${json["courseName"]}',style: TextStyle(fontSize: 12),maxLines: 2,),
                )
              ],
            ),top: 50,left: 10,),
            Positioned(child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('时间：',style: TextStyle(fontSize: 15),),
                Text('${json["examTime"].toString().replaceAll(" ", "\n")}',style: TextStyle(fontSize: 12),)
              ],
            ),top: 90,left: 10,),
            Positioned(child: Row(
              children: [
                Text('考场：',style: TextStyle(fontSize: 15),),
                Text('${json["examRoom"]}',style: TextStyle(fontSize: 12),)
              ],
            ),top: 140,left: 10,),
            Positioned(child: Row(
              children: [
                Text('座位号：',style: TextStyle(fontSize: 15),),
                Text('${json["seatNumber"]}',style: TextStyle(fontSize: 12),)
              ],
            ),top: 180,left: 10,)
            // Text('科目：高等数学'),
            // Text('时间：1231231231312313'),
            // Text('考场：多媒体教室3333'),
            // Text('座位号：28')
          ]
      ),
    );
  }

}
