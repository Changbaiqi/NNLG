import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/utils/ToastUtil.dart';


class showCourseTableMessage {


  dynamic _context;

  showCourseTableMessage(context) {
    _context = context;
  }


  Future show(courseJSON,DateTime dateTime /*授课日期*/) async{

    //ToastUtil.show(courseJSON.toString());
    return showModalBottomSheet(
        context: _context,
        isScrollControlled: true,
        builder: (builder){
          return _showCourseTableMessageChild(courseJson: courseJSON, dateTime: dateTime);
        });


  }




}


class _showCourseTableMessageChild extends StatefulWidget {
  var courseJson;
  DateTime dateTime;
  _showCourseTableMessageChild({Key? key, required this.courseJson, required this.dateTime}) : super(key: key);
  @override
  State<_showCourseTableMessageChild> createState() => _showCourseTableMessageChildState();
}

class _showCourseTableMessageChildState extends State<_showCourseTableMessageChild> {
  int _nowIndex =1;
  int _sumIndex = 0;
  List<Widget> list=[];
  var courseJSON;
  DateTime dateTime= DateTime.now();


  @override
  void initState() {
    courseJSON = widget.courseJson;
    dateTime = widget.dateTime;
    _sumIndex = courseJSON.length;
    for(int i =0 ; i < courseJSON.length; ++i){
      list.add(ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [Text('课程：',style: TextStyle(fontSize: 16),),Text('${courseJSON[i]['courseName']}')],),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [Text('授课地点：',style: TextStyle(fontSize: 16),),Text('${courseJSON[i]['courseClassRoom']}')],),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [Text('授课日期时间：',style: TextStyle(fontSize: 16),),Text('${dateTime.month}月${dateTime.day}日   ${courseJSON[i]['courseTime']}')],),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(children: [Text('授课老师：',style: TextStyle(fontSize: 16),),Text('${courseJSON[i]['courseTeacher']}')],),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 20,
            child: Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0),child: Text("${_nowIndex}/${_sumIndex}"),),
          ),
          Expanded(
              flex: 1,
              child: PageView(
                children: list,
                onPageChanged: (int index){
                  _nowIndex = index+1;
                  setState(() {});
                },
                reverse: false,
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  }, child: Text('确定')
              ),
            ),
          )


        ],
      ),
    );
  }
}
