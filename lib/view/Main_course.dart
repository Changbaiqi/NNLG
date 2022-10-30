import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/WeekDayForm.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
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

  updateTitle(String text){
    setState((){
      _title = text;
    });
  }


  @override
  void initState() {
    _main_courseState = this;
    setState((){
      _title = '第${CourseData.nowWeek}周';
    });
  }

  Future<void> _onRefresh() async {
    await CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(icon: Image.asset('images/start.png',height: 25,width: 25,color: Colors.white70,),onPressed: (){course_listState?.updatePreviousPage();},),
            Text('${_title}'),
            IconButton(icon: Image.asset('images/end.png',height: 25,width: 25,color: Colors.white70,),onPressed: (){course_listState?.updateNextPage();},),
          ],
        ),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context,index){
              return Container(
                height: MediaQuery.of(context).size.height/1.3,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    //Image.asset('images/black.webp',height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,fit: BoxFit.fill,),
                    Course_List()
                  ],
                ),
              );
            }),
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

  Widget _loading = Center(child: Text('Loading...',style: TextStyle(fontSize: 10),),);

  //用于寄存当前所在的周数，便于重新加载页面的时候跳转到此
  static int _nowIndex = CourseData.nowWeek-1;

  final PageController _pageController= PageController(
    initialPage: CourseData.nowWeek-1,
  );

  //课表显示的列表
  List<Widget> courseWeek = [];


  //用于外部调用的重新加载课表(无任何课表数据的重载)
  updateNull(){
    try {
      setState(() {
        //course_listState?.indexNotifier.value++;
        refreshAllCourseTable();
      });
    }catch(e){
      //refreshAllCourseTable();
    }

      course_listState?.indexNotifier.value++;



  }

  //此刷新是连同课表数据一起刷新，相当于重新拉取课表后再刷新
  Future updatePullDataAndRefresh() async {

    await CourseUtil().getAllCourseWeekList("${CourseData.nowCourseList}").then((value){
      course_listState!.updateNull();
    });

  }

  //向下翻一页
  updateNextPage(){
    setState((){
      _pageController.nextPage(duration: Duration(milliseconds: 900), curve: Curves.ease);
    });
  }

  //向上翻一页
  updatePreviousPage(){
    setState((){
      _pageController.previousPage(duration: Duration(milliseconds: 900), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    course_listState = this;
    loadCourseTable();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
             _pageController.jumpToPage(_nowIndex);
           //_pageController.animateToPage(_nowIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    });

    print('测试加载');
  }


  //每一周的表格显示的滑动父窗口
  Widget viewPage(){

    return PageView(
      onPageChanged: (int index){
        _nowIndex = index;
        _main_courseState?.updateTitle('第${index+1}周');
        print('当前页面时$index');
      },
      reverse: false,
      scrollDirection: Axis.horizontal,
      controller: _pageController,
      children: courseWeek,
    );
  }

  //表格内每一项的组件
  Widget courseTableWidget(courseJSON,DateTime dateTime/*传入相应的授课日期*/){

    return courseJSON['courseName'] == null ? Center(child: Text('无课',style: TextStyle(fontSize: 12),),): Container(
      child: Padding(
        padding: EdgeInsets.all(2.5),
        child: Container(
          decoration: new BoxDecoration(
            //背景
            color: Color.fromARGB( (dateTime.month==DateTime.now().month)&&(dateTime.day==DateTime.now().day)  ? 130:30, 59, 52, 86),
            //设置四周圆角 角度
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            //设置四周边框
            border: new Border.all(width: 1, color: Color.fromARGB(80, 59, 52, 86)),
          ),
          child: InkWell(
            child: Text('${courseJSON['courseName']}',style: TextStyle(fontSize: 12),),
            onTap: (){
              //ToastUtil.show('${courseJSON['courseName']}');
              //debugPrint(courseJSON.toString());
              showCourseTableMessage(context).show(courseJSON,dateTime);
            },
          ),
        ),
      ),
    );
  }



  //如果出现Each Child must be laid out exactly once那么很大可能bug出现在这里！！！！！！！！！！！！！！
  //用来陈列数据列表用的
  void refreshAllCourseTable(){
    //用来寄存每周的课表的json数据
    List<String> allList = CourseData.weekCourseList;

    //开学时间
    DateTime startSchoolTime = DateTime(
        int.parse(CourseData.schoolOpenTime.split('/')[0]),
        int.parse(CourseData.schoolOpenTime.split('/')[1]),
        int.parse(CourseData.schoolOpenTime.split('/')[2])
    );


    //临时存储courseWeek列表变量
    List<Widget> _resCourseWeek = [];
    for (int i = 0; i < allList.length; ++i) {
      List _courseList = [
      ];

      /*if(i==6)
        debugPrint("${allList[i]}\n");
*/

      List json = jsonDecode(allList[i]);
      List _resCourseList = [];
      for (int x = 0; x < json.length; ++x) {
        if( i==6){
          debugPrint("这是第${x+1}周");
          debugPrint("${json[x]}");
        }

        for (int y = 0; y < json[x].length; ++y) {

          //添加授课时间json
          (json[x][y] as LinkedHashMap<String,dynamic>).addAll({"courseTime":"${CourseData.courseTime[x]}"});
          _resCourseList.add(courseTableWidget(json[x][y] ?? "无课",startSchoolTime.add(Duration(days: y) /*传入相应的授课日期*/)));

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
  }else{
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

        builder: (BuildContext context,int value,Widget? child){
          return viewPageVar??Center(child: Text('正在加载...'),);
        },
      child: viewPageVar??Center(child: Text('正在加载...'),),

    );
  }


  Widget courseTable(List tableWidgetList,DateTime dateTime){

    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.white70),
          children: [
            TableRow(
                children: [
                  Text(''),
                  Text('周${WeekDayForm.Chinese(dateTime.weekday)}\n${dateTime.month}/${dateTime.day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 1)).weekday)}\n${dateTime.add(Duration(days: 1)).month}/${dateTime.add(Duration(days: 1)).day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 2)).weekday)}\n${dateTime.add(Duration(days: 2)).month}/${dateTime.add(Duration(days: 2)).day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 3)).weekday)}\n${dateTime.add(Duration(days: 3)).month}/${dateTime.add(Duration(days: 3)).day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 4)).weekday)}\n${dateTime.add(Duration(days: 4)).month}/${dateTime.add(Duration(days: 4)).day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 5)).weekday)}\n${dateTime.add(Duration(days: 5)).month}/${dateTime.add(Duration(days: 5)).day}',textAlign: TextAlign.center,),
                  Text('周${WeekDayForm.Chinese(dateTime.add(Duration(days: 6)).weekday)}\n${dateTime.add(Duration(days: 6)).month}/${dateTime.add(Duration(days: 6)).day}',textAlign: TextAlign.center,),
                ]
            ),
          ],
        ),
        Expanded(
            flex: 1,
            child: ListView(
              children: [
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('1',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[0].split("-")[0]}\n至\n${CourseData.courseTime[0].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=1?tableWidgetList[0]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=2?tableWidgetList[1]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=3?tableWidgetList[2]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=4?tableWidgetList[3]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=5?tableWidgetList[4]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=6?tableWidgetList[5]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=7?tableWidgetList[6]:_loading,
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('2',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[1].split("-")[0]}\n至\n${CourseData.courseTime[1].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=8?tableWidgetList[7]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=9?tableWidgetList[8]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=10?tableWidgetList[9]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=11?tableWidgetList[10]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=12?tableWidgetList[11]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=13?tableWidgetList[12]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=14?tableWidgetList[13]:_loading,
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('3',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[2].split("-")[0]}\n至\n${CourseData.courseTime[2].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=15?tableWidgetList[14]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=16?tableWidgetList[15]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=17?tableWidgetList[16]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=18?tableWidgetList[17]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=19?tableWidgetList[18]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=20?tableWidgetList[19]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=21?tableWidgetList[20]:_loading,
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('4',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[3].split("-")[0]}\n至\n${CourseData.courseTime[3].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=22?tableWidgetList[21]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=23?tableWidgetList[22]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=24?tableWidgetList[23]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=25?tableWidgetList[24]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=26?tableWidgetList[25]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=27?tableWidgetList[26]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=28?tableWidgetList[27]:_loading,
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('5',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[4].split("-")[0]}\n至\n${CourseData.courseTime[4].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=29?tableWidgetList[28]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=30?tableWidgetList[29]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=31?tableWidgetList[30]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=32?tableWidgetList[31]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=33?tableWidgetList[32]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=34?tableWidgetList[33]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=35?tableWidgetList[34]:_loading,
                          ),
                        ]
                    ),
                    TableRow(
                        children: [
                          Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(child: Text('6',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),),
                                Center(child: Text('${CourseData.courseTime[5].split("-")[0]}\n至\n${CourseData.courseTime[5].split("-")[1]}',textAlign: TextAlign.center,style: TextStyle(fontSize: 10),),),
                              ],
                            ),
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=36?tableWidgetList[35]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=37?tableWidgetList[36]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=38?tableWidgetList[37]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=39?tableWidgetList[38]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=40?tableWidgetList[39]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=41?tableWidgetList[40]:_loading,
                          ),
                          Container(
                            height: 100,
                            child: tableWidgetList.length>=42?tableWidgetList[41]:_loading,
                          ),
                        ]
                    ),


                  ],
                )
              ],
            )),

      ],
    );

  }





}


