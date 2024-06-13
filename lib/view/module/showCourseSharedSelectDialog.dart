import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/Course_SharedView.dart';
import 'package:nnlg/view/router/Routes.dart';



class showCourseSharedSelectDialog extends Dialog {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(boxShadow: [
          // BoxShadow(color: Colors.white,B)
        ]),
        child: _CourseSharedSelect(),
      ),
    );
  }
}

class _CourseSharedSelect extends StatefulWidget {
  const _CourseSharedSelect({Key? key}) : super(key: key);

  @override
  State<_CourseSharedSelect> createState() => _CourseSharedSelectState();
}

class _CourseSharedSelectState extends State<_CourseSharedSelect> with SingleTickerProviderStateMixin {
  AnimationController? _animationController; //动画控制器
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _topButtonAnimation;
  Animation<double>? _bottomButtonAnimation; //底部按钮
  Animation<double>? _buttonOpacityAnimation;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        child: Stack(
          children: [
            Align(
              child: InkWell(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX:_backgroundAnimation!.value,sigmaY:_backgroundAnimation!.value),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                onTap: (){
                  _animationController!.reverse().then((value) => Navigator.pop(context));
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, _topButtonAnimation!.value),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Opacity(opacity: _buttonOpacityAnimation!.value,child: ElevatedButton(
                        child: Text('查询'),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(150)))),
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                          //   return Course_SharedView();
                          // }));
                          Get.toNamed(Routes.SharedCourseChoose);
                          _animationController!.reverse().then((value) => Navigator.pop(context));
                        },
                      ),),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, _bottomButtonAnimation!.value, 0, 0),
                    child: Container(
                      height: 120,
                      width: 120,
                      child: Opacity(
                        opacity: _buttonOpacityAnimation!.value,
                        child: ElevatedButton(
                          child: Text('共享'),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(150)))),
                          onPressed: () {
                            Get.toNamed(Routes.CourseShared);
                            _animationController!.reverse().then((value) => Navigator.pop(context));
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onWillPop: () async {
          _animationController!.reverse().then((value) => Navigator.pop(context));
          return false;
        },
      ),
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 动画
   * [date] 17:53 2024/2/12
   * [param] null
   * [return]
   */
  backgroundAnimation(){

    _animationController = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 200));

    CurvedAnimation(parent: _animationController!, curve: Curves.decelerate); //动画效果
    _animationController!.addListener(() {setState(() {

    }); });


    //背景动画
    _backgroundAnimation = Tween(begin: 0.0,end: 20.0).animate(_animationController!); //动画绑定值

    _topButtonAnimation = Tween(begin: 30.0,end: 10.0).animate(_animationController!); //顶部按钮
    _buttonOpacityAnimation = Tween(begin: 0.0,end: 1.0).animate(_animationController!); //透明度

    _bottomButtonAnimation = Tween(begin: 20.0,end: 10.0).animate(_animationController!); //底部按钮


    _animationController!.forward();



  }
  @override
  void initState() {
    super.initState();
    backgroundAnimation();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
