import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/WeekDayForm.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/view/module/showCourseTableMessage.dart';

import 'state.dart';

class CourseSharedShowViewLogic extends GetxController {
  final CourseSharedShowViewState state = CourseSharedShowViewState();
  BuildContext? context;

  Widget loading = Center(
    child: Text(
      'Loading...',
      style: TextStyle(fontSize: 10),
    ),
  );

  final PageController pageController = PageController(
    initialPage: CourseData.nowWeek.value - 1,
  );

  updateTitle(String text) {
    state.title.value = text;
  }

  //向下翻一页
  updateNextPage() {
    pageController.nextPage(
        duration: Duration(milliseconds: 900), curve: Curves.ease);
  }

  //向上翻一页
  updatePreviousPage() {
    pageController.previousPage(
        duration: Duration(milliseconds: 900), curve: Curves.ease);
  }

  //刷新课表
  Future<void> onRefresh() async {
    await CourseUtil()
        .getAllCourseWeekList("${CourseData.nowCourseList.value}");
  }

  //如果出现Each Child must be laid out exactly once那么很大可能bug出现在这里！！！！！！！！！！！！！！
  //用来陈列数据列表或者刷新课表视图用
  List<Widget> refreshAllCourseTable(List<dynamic> allList) {
    // print(allList);
    //开学时间
    DateTime startSchoolTime = DateTime(
        int.parse(CourseData.schoolOpenTime.value.split('/')[0]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[1]),
        int.parse(CourseData.schoolOpenTime.value.split('/')[2]));

    //临时存储courseWeek列表变量
    List<Widget> _resCourseWeek = [];
    for (int i = 0; i < allList.length; ++i) {
      List _courseList = [];

      List json = allList[i];
      List _resCourseList = [];
      for (int x = 0; x < json.length; ++x) {
        if (i == 6) {
          debugPrint("这是第${x + 1}周");
          // debugPrint("${json[x]}");
        }

        for (int y = 0; y < json[x].length; ++y) {
          // print(json[x][y]);
          //判断是否为空课
          for (int z = 0; z < json[x][y].length; ++z) {
            //添加授课时间json
            (json[x][y][z] as LinkedHashMap<String, dynamic>)
                .addAll({"courseTime": "${CourseData.courseTime.value[x]}"});
          }
          _resCourseList.add(courseTableWidget(json[x][y] ?? "无课",
              startSchoolTime.add(Duration(days: y) /*传入相应的授课日期*/)));
        }
      }

      //直接替换
      _courseList.clear();
      _courseList = _resCourseList;

      //其中的courseTable就是创建一个课表页面
      _resCourseWeek.add(courseTable(_courseList, startSchoolTime));
      startSchoolTime = startSchoolTime.add(Duration(days: 7));
    }

    //直接替换
    // state.courseWeek.value.clear();
    // state.courseWeek.value = _resCourseWeek;
    // state.courseWeek.refresh();

    // state.viewPageVar.value = viewPage();
    // state.viewPageVar.refresh();
    // ShareDateUtil().setWeekCourseList(CourseData.weekCourseList.value);
    return _resCourseWeek;
  }

  //用于刷新列表控件用的
  void loadCourseTable() {
    if (CourseData.weekCourseList.value == null ||
        CourseData.weekCourseList.value.length == 0) {
      Future.wait([
        CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList.value}"),
      ]).then((value) {
        //获取到数据后刷新
        refreshAllCourseTable(CourseData.weekCourseList.value);
      });
    } else {
      refreshAllCourseTable(CourseData.weekCourseList.value);
    }
  }

  //表格内每一项的组件
  Widget courseTableWidget(courseJSON, DateTime dateTime /*传入相应的授课日期*/,
      {Color? color}) {
    return courseJSON.length == 0
        ? Center(
      child: Text(
        '无课',
        style: TextStyle(fontSize: 12),
      ),
    )
        : Container(
      child: Padding(
        padding: EdgeInsets.all(2.5),
        child: Container(
          decoration: new BoxDecoration(
            //背景
            color: Color.fromARGB(
                (dateTime.month == DateTime.now().month) &&
                    (dateTime.day == DateTime.now().day)
                    ? 130
                    : 30,
                59,
                52,
                86),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
            border: new Border.all(
                width: 1, color: Color.fromARGB(80, 59, 52, 86)),
          ),
          child: InkWell(
            child: Text(
              '${courseJSON.length > 1 ? "有多门课程同时进行，点击查看详细" : courseJSON[0]['courseName']}',
              style: TextStyle(
                  fontSize: 12,
                  color:
                  courseJSON.length > 1 ? Colors.red : Colors.black),
            ),
            onTap: () {
              //ToastUtil.show('${courseJSON['courseName']}');
              //debugPrint(courseJSON.toString());
              showCourseTableMessage(context).show(courseJSON, dateTime);
            },
          ),
        ),
      ),
    );
  }

  List<TableRow> forWidgetList(List tableWidgetList) {
    List<TableRow> list = [];
    //左侧日期
    for (int i = 0; i <= 5; ++i) {
      TableRow tableRow = TableRow(children: [
        Container(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  '${i + 1}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Text(
                  '${CourseData.courseTime.value[i].split("-")[0]}\n至\n${CourseData.courseTime.value[i].split("-")[1]}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 1
              ? tableWidgetList[(i * 7) + 0]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 2
              ? tableWidgetList[(i * 7) + 1]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 3
              ? tableWidgetList[(i * 7) + 2]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 4
              ? tableWidgetList[(i * 7) + 3]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 5
              ? tableWidgetList[(i * 7) + 4]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 6
              ? tableWidgetList[(i * 7) + 5]
              : loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 7
              ? tableWidgetList[(i * 7) + 6]
              : loading,
        ),
      ]);
      list.add(tableRow);
    }
    return list;
  }

  /**
   *
   * 课表格子展示
   */
  Widget courseTable(List tableWidgetList, DateTime dateTime) {
    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.white70),
          children: [
            TableRow(children: [
              Text(''),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month == dateTime.month &&
                        DateTime.now().day == dateTime.day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month == dateTime.month &&
                        DateTime.now().day == dateTime.day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.weekday)}\n${dateTime.month}/${dateTime.day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 1)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 1)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 1)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 1)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 1)).weekday)}\n${dateTime.add(Duration(days: 1)).month}/${dateTime.add(Duration(days: 1)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 2)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 2)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 2)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 2)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 2)).weekday)}\n${dateTime.add(Duration(days: 2)).month}/${dateTime.add(Duration(days: 2)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 3)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 3)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 3)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 3)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 3)).weekday)}\n${dateTime.add(Duration(days: 3)).month}/${dateTime.add(Duration(days: 3)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 4)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 4)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 4)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 4)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 4)).weekday)}\n${dateTime.add(Duration(days: 4)).month}/${dateTime.add(Duration(days: 4)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 5)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 5)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 5)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 5)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 5)).weekday)}\n${dateTime.add(Duration(days: 5)).month}/${dateTime.add(Duration(days: 5)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: DateTime.now().month ==
                        dateTime.add(Duration(days: 6)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 6)).day
                        ? Color.fromARGB(30, 59, 52, 86)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: DateTime.now().month ==
                        dateTime.add(Duration(days: 6)).month &&
                        DateTime.now().day ==
                            dateTime.add(Duration(days: 6)).day
                        ? Border.all(color: Color.fromARGB(130, 59, 52, 86))
                        : Border.all(color: Colors.transparent)),
                child: Text(
                  '周${WeekDayForm.Chinese(dateTime.add(Duration(days: 6)).weekday)}\n${dateTime.add(Duration(days: 6)).month}/${dateTime.add(Duration(days: 6)).day}',
                  textAlign: TextAlign.center,
                ),
              ),
            ]),
          ],
        ),
        Expanded(
          flex: 1,
          child: ListView(
            children: [
              Table(
                border: TableBorder.all(color: Colors.black, width: 0.5),
                children: forWidgetList(tableWidgetList),
              )
            ],
          ),
        ),
      ],
    );
  }

  @override
  void onInit() {
    state.accountData.value = Get.arguments['data'];
    // refreshAllCourseTable(CourseData.weekCourseList.value);
    //每次进入课表都进行一次课表同步
    state.getShareCourseData("new");
    onRefresh();
    state.title.value = '第${CourseData.nowWeek.value}周';
  }
}
