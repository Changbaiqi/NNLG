import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/WeekDayForm.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/Course_Shared.dart';
import 'package:nnlg/view/module/showCourseSharedSelectDialog.dart';
import 'package:nnlg/view/module/showCourseTableMessage.dart';

class Main_course extends StatefulWidget {
  const Main_course({Key? key}) : super(key: key);

  //_Main_courseState _main_courseState = _Main_courseState();
  @override
  State<Main_course> createState() => _Main_courseState();

/*updateTitle(String text){
    _main_courseState.updateTitle(text);
  }*/
}

_Main_courseState? _main_courseState;

class _Main_courseState extends State<Main_course> {
  String _title = '加载中...';

  updateTitle(String text) {
    setState(() {
      _title = text;
    });
  }

  @override
  void initState() {
    _main_courseState = this;
    setState(() {
      _title = '第${CourseData.nowWeek}周';
    });
  }

  Future<void> _onRefresh() async {
    await CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}");
    ToastUtil.show('同步完毕');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        title: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Row(
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/images/start.png',
                      height: 25,
                      width: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      course_listState?.updatePreviousPage();
                    },
                  ),
                  Text(
                    '${_title}',
                    style: TextStyle(color: Colors.black),
                  ),
                  IconButton(
                    icon: Image.asset(
                      'assets/images/end.png',
                      height: 25,
                      width: 25,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      course_listState?.updateNextPage();
                    },
                  ),
                ],
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(
                      Icons.cached_sharp,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      '课表同步',
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    )
                  ],
                ),
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (builder) {
                  //       return Center(
                  //         child: showCourseSharedSelectDialog(),
                  //       );
                  //     });
                  ToastUtil.show('正在同步官网课表...');
                  _onRefresh();
                  //ToastUtil.show('敬请期待...');
                },
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(
                      Icons.face_retouching_natural,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      '共享课表',
                      style: TextStyle(fontSize: 8, color: Colors.black),
                    )
                  ],
                ),
                onPressed: () {
                  // showDialog(
                  //     context: context,
                  //     builder: (builder) {
                  //       return Center(
                  //         child: showCourseSharedSelectDialog(),
                  //       );
                  //     });
                  ToastUtil.show('敬请期待...');
                },
              )
            ]),
          ],
        ),
      ),
      body: RefreshIndicator(
        // Container(
        //   height: MediaQuery.of(context).size.height,
        //   //height: MediaQuery.of(context).size.height,
        //   child: Course_List(),
        // )
        child: Container(
          height: MediaQuery.of(context).size.height,
          //height: MediaQuery.of(context).size.height,
          child: Course_List(),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }
}

class Course_List extends StatefulWidget {
  const Course_List({Key? key}) : super(key: key);

  @override
  State<Course_List> createState() => Course_ListState();
}

Course_ListState? course_listState;

class Course_ListState extends State<Course_List> {
  Widget _loading = Center(
    child: Text(
      'Loading...',
      style: TextStyle(fontSize: 10),
    ),
  );

  //用于寄存当前所在的周数，便于重新加载页面的时候跳转到此
  static int _nowIndex = CourseData.nowWeek - 1;

  final PageController _pageController = PageController(
    initialPage: CourseData.nowWeek - 1,
  );

  //课表显示的列表
  List<Widget> courseWeek = [];

  //用于外部调用的重新加载课表(无任何课表数据的重载)
  updateNull() {
    try {
      setState(() {
        //course_listState?.indexNotifier.value++;
        refreshAllCourseTable();
      });
    } catch (e) {
      //refreshAllCourseTable();
    }

    course_listState?.indexNotifier.value++;
  }

  //此刷新是连同课表数据一起刷新，相当于重新拉取课表后再刷新
  Future updatePullDataAndRefresh() async {
    await CourseUtil()
        .getAllCourseWeekList("${CourseData.nowCourseList}")
        .then((value) {
      course_listState!.updateNull();
    });
  }

  //向下翻一页
  updateNextPage() {
    setState(() {
      _pageController.nextPage(
          duration: Duration(milliseconds: 900), curve: Curves.ease);
    });
  }

  //向上翻一页
  updatePreviousPage() {
    setState(() {
      _pageController.previousPage(
          duration: Duration(milliseconds: 900), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    course_listState = this;
    loadCourseTable();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.jumpToPage(_nowIndex);
      //_pageController.animateToPage(_nowIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    });

    // print('测试加载');
  }

  //每一周的表格显示的滑动父窗口
  Widget viewPage() {
    return PageView(
      onPageChanged: (int index) {
        _nowIndex = index;
        _main_courseState?.updateTitle('第${index + 1}周');
        print('当前页面时$index');
      },
      reverse: false,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      children: courseWeek,
    );
  }

  //表格内每一项的组件
  Widget courseTableWidget(courseJSON, DateTime dateTime /*传入相应的授课日期*/,{Color? color}) {
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
                    '${courseJSON.length>1? "有多门课程同时进行，点击查看详细":courseJSON[0]['courseName']}',
                    style: TextStyle(fontSize: 12,color: courseJSON.length>1?Colors.red:Colors.black),
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

  //如果出现Each Child must be laid out exactly once那么很大可能bug出现在这里！！！！！！！！！！！！！！
  //用来陈列数据列表用的
  void refreshAllCourseTable() {
    //用来寄存每周的课表的json数据
    List<String> allList = CourseData.weekCourseList;
    // print(allList);
    //开学时间
    DateTime startSchoolTime = DateTime(
        int.parse(CourseData.schoolOpenTime.split('/')[0]),
        int.parse(CourseData.schoolOpenTime.split('/')[1]),
        int.parse(CourseData.schoolOpenTime.split('/')[2]));

    //临时存储courseWeek列表变量
    List<Widget> _resCourseWeek = [];
    for (int i = 0; i < allList.length; ++i) {
      List _courseList = [];

      /*if(i==6)
        debugPrint("${allList[i]}\n");
*/

      List json = jsonDecode(allList[i]);
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
                .addAll({"courseTime": "${CourseData.courseTime[x]}"});
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
    courseWeek.clear();
    courseWeek = _resCourseWeek;

    setState(() {
      viewPageVar = viewPage();
    });

    ShareDateUtil().setWeekCourseList(CourseData.weekCourseList);
  }

  //用于刷新列表控件用的
  void loadCourseTable() {
    if (CourseData.weekCourseList == null ||
        CourseData.weekCourseList.length == 0) {
      Future.wait([
        CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}"),
      ]).then((value) {
        //获取到数据后刷新
        refreshAllCourseTable();
      });
    } else {
      refreshAllCourseTable();
    }
  }

//viewPageVar??Center(child: Text('正在加载...'),)
  Widget? viewPageVar;
  ValueNotifier<int> indexNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: indexNotifier,
      builder: (BuildContext context, int value, Widget? child) {
        return viewPageVar ??
            Center(
              child: Text('正在加载...'),
            );
      },
      child: viewPageVar ??
          Center(
            child: Text('正在加载...'),
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
                  '${CourseData.courseTime[i].split("-")[0]}\n至\n${CourseData.courseTime[i].split("-")[1]}',
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
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 2
              ? tableWidgetList[(i * 7) + 1]
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 3
              ? tableWidgetList[(i * 7) + 2]
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 4
              ? tableWidgetList[(i * 7) + 3]
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 5
              ? tableWidgetList[(i * 7) + 4]
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 6
              ? tableWidgetList[(i * 7) + 5]
              : _loading,
        ),
        Container(
          height: 100,
          child: tableWidgetList.length >= (i * 7) + 7
              ? tableWidgetList[(i * 7) + 6]
              : _loading,
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
}
