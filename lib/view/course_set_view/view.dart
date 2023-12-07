import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/module/selectBeginCourseTimeSheet.dart';
import 'package:nnlg/view/module/selectDateSheet.dart';
import 'package:nnlg/view/module/selectNowCourseListSheet.dart';
import 'package:nnlg/view/module/showCourseNumSheet.dart';

import 'logic.dart';

class CourseSetViewPage extends StatelessWidget {
  CourseSetViewPage({Key? key}) : super(key: key);
  final logic = Get.put(CourseSetViewLogic());
  final state = Get.find<CourseSetViewLogic>().state;



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text('课表设置',style: TextStyle(fontSize:20,color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(()=>ListView(
        children: [

          Padding(padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
            child: Text('基本设置',style: TextStyle(fontSize: 13,color: Colors.black54),),),
          InkWell(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('学期课表',style: TextStyle(fontSize: 20),),
                          Text('此项为必选，会根据官网拉取最新的课表数据',style: TextStyle(fontSize: 10,color: Colors.black45),),
                        ],
                      ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text('${CourseData.nowCourseList.value}',style: TextStyle(fontSize: 14,color: Colors.black45),),),
                          Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,)
                        ],
                      ),)
                  ],
                ),
              ),),
            onTap: (){

              //用于选择开学年月日
              selectNowCourseListSheet(context).show().then((value){
                if(value!=null){
                  Get.snackbar("课表通知", "正在切换课表...",duration: Duration(milliseconds: 1500),);
                  CourseData.nowCourseList.value = value;
                  ShareDateUtil().setNowCourseList(value);
                  CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}").then((value){
                    Get.snackbar("课表通知", "课表切换成功",duration: Duration(milliseconds: 1500),);
                  });


                }
              });

            },
          ),
          InkWell(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('开学时间',style: TextStyle(fontSize: 20),),
                          Text('判断是否为假期中以及自动判断周数',style: TextStyle(fontSize: 10,color: Colors.black45),),
                        ],
                      ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text('${CourseData.schoolOpenTime.value}',style: TextStyle(fontSize: 14,color: Colors.black45),),),
                          Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,)
                        ],
                      ),)
                  ],
                ),
              ),),
            onTap: (){

              //用于选择开学年月日
              selectDateSheet(context).show().then((value){
                if(value!=null) {

                  CourseData.schoolOpenTime.value = value;
                  CourseData.nowWeek.value = CourseUtil.getNowWeek(CourseData.schoolOpenTime.value, CourseData.ansWeek.value);
                  ShareDateUtil().setSchoolOpenDate(CourseData.schoolOpenTime.value).then((value){
                    // course_listState?.refreshAllCourseTable();
                  });//记录本地存储
                }

              });

            },
          ),
          InkWell(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('当前周数',style: TextStyle(fontSize: 20),),
                          Text('开学到现在第几周',style: TextStyle(fontSize: 10,color: Colors.black45),),
                        ],
                      ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text('${CourseData.nowWeek.value==0?'假期中':CourseData.nowWeek.value}',style: TextStyle(fontSize: 14,color: Colors.black45),),),
                          Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,)
                        ],
                      ),)
                  ],
                ),
              ),),
            onTap: (){

              Get.snackbar("课表通知", "${CourseData.nowWeek.value==0 ? "假期中": '当前第${CourseData.nowWeek.value}周'}",duration: Duration(milliseconds: 1500),);
            },
          ),
          InkWell(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('本学期总周数',style: TextStyle(fontSize: 20),),
                          Text('请选择本学期总共多少周',style: TextStyle(fontSize: 10,color: Colors.black45),),
                        ],
                      ),),
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                            child: Text('${CourseData.ansWeek.value}',style: TextStyle(fontSize: 14,color: Colors.black45),),),
                          Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,)
                        ],
                      ),)
                  ],
                ),
              ),),
            onTap: () async {
              showCourseNumSheet(context).show().then((value){
                if(value!=null){
                  CourseData.ansWeek.value = value;
                  ShareDateUtil().setSemesterWeekNum(CourseData.ansWeek.value);
                  // ToastUtil.show('正在刷新课表...');
                  // course_listState?.updatePullDataAndRefresh().then((value){
                  //   ToastUtil.show('刷新成功');
                  // });

                }
              });

            },
          ),

          InkWell(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                  height: 400,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('各大节课时间',style: TextStyle(fontSize: 20),),
                                Text('调节每大节课的起止时间',style: TextStyle(fontSize: 10,color: Colors.black45),),
                              ],
                            ),),
                          Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Row(
                              children: [
                                Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,)
                              ],
                            ),)



                        ],),

                      Column(
                        children: [


                          Padding(padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第一大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[0]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第二大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[1]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第三大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[2]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第四大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[3]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第五大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[4]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),),
                          Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('第六大节',style: TextStyle(fontSize: 15,color: Colors.black45),),
                                Text('${CourseData.courseTime.value[5]}',style: TextStyle(fontSize: 15,color: Colors.black45),)
                              ],),)


                        ],
                      )


                    ],
                  )
              ),),
            onTap: () async {

              //调节时间

              await selectBeginCourseTimeSheet(context).show().then((resDataTime) async {
                if(resDataTime!=null){


                  List<String> resTime=[];
                  //用于刷新控件
                  for( int i =1 ; i <= CourseData.courseTime.value.length ; ++i){
                    resTime.add('${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}');
                    // CourseData.courseTime.value[i-1] = '${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}';
                  }
                  //用于刷新课表的时间显示控件
                  await ShareDateUtil().setCourseTimeList(resTime).then((value){
                    Get.snackbar("课表通知", "修改成功",duration: Duration(milliseconds: 1500),);
                  });


                }
              });




            },
          )


        ],
      )),
    );
  }
}
