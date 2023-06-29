
import 'package:flutter/material.dart';
import 'package:nnlg/view/Course_SharedView.dart';
import 'package:nnlg/view/Main.dart';

class showCourseSharedSelectDialog extends Dialog{


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 120,
      color: Colors.transparent,
      child: _CourseSharedSelect(),
    );
  }
}



class _CourseSharedSelect extends StatefulWidget {
  const _CourseSharedSelect({Key? key}) : super(key: key);

  @override
  State<_CourseSharedSelect> createState() => _CourseSharedSelectState();
}

class _CourseSharedSelectState extends State<_CourseSharedSelect> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Container(
            height: 120,
            width: 120,
            child: ElevatedButton(
              child: Text('查看'),
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(150)
                      )
                  )
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                  return Course_SharedView();
                }));
              },
            ),),),
          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Container(
              height: 120,
              width: 120,
              child: ElevatedButton(
                child: Text('分享'),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(150)
                        )
                    )
                ),
                onPressed: () {
                },
              ),),),

        ],
      ),
    );
  }
}
