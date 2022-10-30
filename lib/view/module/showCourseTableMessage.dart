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
          return Container(
            height: 300,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                    child: ListView(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(children: [Text('课程：',style: TextStyle(fontSize: 16),),Text('${courseJSON['courseName']}')],),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(children: [Text('授课地点：',style: TextStyle(fontSize: 16),),Text('${courseJSON['courseClassRoom']}')],),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(children: [Text('授课日期时间：',style: TextStyle(fontSize: 16),),Text('${dateTime.month}月${dateTime.day}日   ${courseJSON['courseTime']}')],),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Row(children: [Text('授课老师：',style: TextStyle(fontSize: 16),),Text('${courseJSON['courseTeacher']}')],),
                        ),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    height: 50,
                    width: MediaQuery.of(_context).size.width,
                    child: ElevatedButton(
                        onPressed: (){
                          Navigator.of(_context).pop();
                        }, child: Text('确定')
                    ),
                  ),
                )


              ],
            ),
          );
        });


  }




}