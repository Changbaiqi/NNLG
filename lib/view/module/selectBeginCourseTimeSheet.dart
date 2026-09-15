
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/WeekDayForm.dart';
import 'package:callo/utils/GlassUI.dart';

/*
 * [author] 长白崎
 * [date] 2024/2/10 21:38
 * [description] TODO 各大节课时间选择
 */
class selectBeginCourseTimeSheet{

  dynamic _context;

  selectBeginCourseTimeSheet(context){
    _context = context;

  }

  Future show() async {

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .35),
      isScrollControlled: true,
        context: _context,
        builder: (builder){
          return GlassCard(
            page: 'course_set_view',
            padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: Ceshi(),
          );
        });


  }



}



class Ceshi extends StatefulWidget {
  const Ceshi({Key? key}) : super(key: key);

  @override
  State<Ceshi> createState() => _CeshiState();
}

class _CeshiState extends State<Ceshi> {



  List<DateTime> resDataTime = [];


  //初始化数据
  _CeshiState(){
    //初始化时间选择存储
    List<String> oneStart = (CourseData.oldCourseTime[0].split("-")[0]).split(":");
    List<String> oneEnd = (CourseData.oldCourseTime[0].split("-")[1]).split(":");

    List<String> twoStart = (CourseData.oldCourseTime[1].split("-")[0]).split(":");
    List<String> twoEnd = (CourseData.oldCourseTime[1].split("-")[1]).split(":");

    List<String> threeStart = (CourseData.oldCourseTime[2].split("-")[0]).split(":");
    List<String> threeEnd = (CourseData.oldCourseTime[2].split("-")[1]).split(":");

    List<String> fourStart = (CourseData.oldCourseTime[3].split("-")[0]).split(":");
    List<String> fourEnd = (CourseData.oldCourseTime[3].split("-")[1]).split(":");

    List<String> fiveStart = (CourseData.oldCourseTime[4].split("-")[0]).split(":");
    List<String> fiveEnd = (CourseData.oldCourseTime[4].split("-")[1]).split(":");

    List<String> sixStart = (CourseData.oldCourseTime[5].split("-")[0]).split(":");
    List<String> sixEnd = (CourseData.oldCourseTime[5].split("-")[1]).split(":");

    resDataTime.add(DateTime(0,0,0, int.parse(oneStart[0]),int.parse(oneStart[1])) );
    resDataTime.add(DateTime(0,0,0, int.parse(oneEnd[0]),int.parse(oneEnd[1])) );

    resDataTime.add(DateTime(0,0,0, int.parse(twoStart[0]),int.parse(twoStart[1]) ) );
    resDataTime.add(DateTime(0,0,0, int.parse(twoEnd[0]),int.parse(twoEnd[1]) ) );

    resDataTime.add(DateTime(0,0,0, int.parse(threeStart[0]),int.parse(threeStart[1]) ) );
    resDataTime.add(DateTime(0,0,0, int.parse(threeEnd[0]),int.parse(threeEnd[1]) ) );

    resDataTime.add(DateTime(0,0,0, int.parse(fourStart[0]),int.parse(fourStart[1]) ) );
    resDataTime.add(DateTime(0,0,0, int.parse(fourEnd[0]),int.parse(fourEnd[1]) ) );

    resDataTime.add(DateTime(0,0,0, int.parse(fiveStart[0]),int.parse(fiveStart[1]) ) );
    resDataTime.add(DateTime(0,0,0, int.parse(fiveEnd[0]),int.parse(fiveEnd[1]) ) );

    resDataTime.add(DateTime(0,0,0, int.parse(sixStart[0]),int.parse(sixStart[1]) ) );
    resDataTime.add(DateTime(0,0,0, int.parse(sixEnd[0]),int.parse(sixEnd[1]) ) );

  }


  List<Widget> hourWidget(){
    List<Widget> hoursList = [];

    for(int i = 0 ; i < 24 ; ++i){
      hoursList.add(Text('${i.toString().padLeft(2,'0')}', style: TextStyle(fontSize: 16, color: GlassTheme.textColor('course_set_view'))));
    }

    return hoursList;
  }

  List<Widget> minuteWidget(){
    List<Widget> hoursList = [];

    for(int i = 0 ; i < 60 ; ++i){
      hoursList.add(Text('${i.toString().padLeft(2,'0')}', style: TextStyle(fontSize: 16, color: GlassTheme.textColor('course_set_view'))));
    }

    return hoursList;
  }

  //选择时间页面控件组合
  Widget chooseWidget(FixedExtentScrollController startControllerHours,FixedExtentScrollController startControllerMinutes,
                      FixedExtentScrollController endControllerHours,FixedExtentScrollController endControllerMinutes ){
    final Color textColor = GlassTheme.textColor('course_set_view');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
              child: _timeColumn(
            label: '上课时间',
            hourController: startControllerHours,
            minuteController: startControllerMinutes,
            onHour: (index) {
              resDataTime[_pageIndex * 2 - 2] = DateTime(
                  0, 0, 0, index, resDataTime[_pageIndex * 2 - 2].minute);
            },
            onMinute: (index) {
              resDataTime[_pageIndex * 2 - 2] = DateTime(
                  0, 0, 0, resDataTime[_pageIndex * 2 - 2].hour, index);
            },
            textColor: textColor,
          )),
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 30),
            color: textColor.withValues(alpha: .2),
          ),
          Expanded(
              child: _timeColumn(
            label: '下课时间',
            hourController: endControllerHours,
            minuteController: endControllerMinutes,
            onHour: (index) {
              resDataTime[_pageIndex * 2 - 1] = DateTime(
                  0, 0, 0, index, resDataTime[_pageIndex * 2 - 1].minute);
            },
            onMinute: (index) {
              resDataTime[_pageIndex * 2 - 1] = DateTime(
                  0, 0, 0, resDataTime[_pageIndex * 2 - 1].hour, index);
            },
            textColor: textColor,
          )),
        ],
      ),
    );
  }

  //单个时间选择列
  Widget _timeColumn({
    required String label,
    required FixedExtentScrollController hourController,
    required FixedExtentScrollController minuteController,
    required ValueChanged<int> onHour,
    required ValueChanged<int> onMinute,
    required Color textColor,
  }) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: textColor.withValues(alpha: .8))),
        const SizedBox(height: 4),
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: ListWheelScrollView(
                itemExtent: 46,
                useMagnifier: true,
                magnification: 1.35,
                controller: hourController,
                onSelectedItemChanged: onHour,
                physics: FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: hourWidget(),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text('时',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
              Expanded(
                  child: ListWheelScrollView(
                itemExtent: 46,
                useMagnifier: true,
                magnification: 1.35,
                controller: minuteController,
                onSelectedItemChanged: onMinute,
                physics: FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics()),
                children: minuteWidget(),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text('分',
                    style: TextStyle(fontSize: 12, color: textColor)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  FixedExtentScrollController oneStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController oneStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController oneEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController oneEndControllerMinutes = FixedExtentScrollController();

  FixedExtentScrollController twoStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController twoStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController twoEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController twoEndControllerMinutes = FixedExtentScrollController();

  FixedExtentScrollController threeStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController threeStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController threeEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController threeEndControllerMinutes = FixedExtentScrollController();

  FixedExtentScrollController fourStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController fourStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController fourEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController fourEndControllerMinutes = FixedExtentScrollController();


  FixedExtentScrollController fiveStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController fiveStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController fiveEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController fiveEndControllerMinutes = FixedExtentScrollController();

  FixedExtentScrollController sixStartControllerHours = FixedExtentScrollController();
  FixedExtentScrollController sixStartControllerMinutes = FixedExtentScrollController();
  FixedExtentScrollController sixEndControllerHours = FixedExtentScrollController();
  FixedExtentScrollController sixEndControllerMinutes = FixedExtentScrollController();

  List<Widget> courseTime(){

    return [
      chooseWidget(oneStartControllerHours,oneStartControllerMinutes,oneEndControllerHours,oneEndControllerMinutes),

      chooseWidget(twoStartControllerHours,twoStartControllerMinutes,twoEndControllerHours,twoEndControllerMinutes),
      chooseWidget(threeStartControllerHours,threeStartControllerMinutes,threeEndControllerHours,threeEndControllerMinutes),
      chooseWidget(fourStartControllerHours,fourStartControllerMinutes,fourEndControllerHours,fourEndControllerMinutes),
      chooseWidget(fiveStartControllerHours,fiveStartControllerMinutes,fiveEndControllerHours,fiveEndControllerMinutes),
      chooseWidget(sixStartControllerHours,sixStartControllerMinutes,sixEndControllerHours,sixEndControllerMinutes)
    ];
  }


  int _pageIndex = 1;//用来指示上面的大节标签
  //专门用来控制课表时间修改的翻页控制----------------------
  PageController _pageController = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      GlassTheme.accentColor('course_set_view'),
                      GlassTheme.accentColor('course_set_view')
                          .withValues(alpha: .5),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '各大节课时间',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GlassTheme.textColor('course_set_view'),
                ),
              ),
              const Spacer(),
              Text(
                '第${WeekDayForm.Chinese(_pageIndex)}大节',
                style: TextStyle(
                  fontSize: 13,
                  color: GlassTheme.textColor('course_set_view')
                      .withValues(alpha: .6),
                ),
              ),
              IconButton(
                icon: Image.asset('assets/images/start.png',
                    height: 20,
                    width: 20,
                    color: GlassTheme.textColor('course_set_view')
                        .withValues(alpha: .7)),
                onPressed: () {
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 900), curve: Curves.ease);
                },
              ),
              IconButton(
                icon: Image.asset('assets/images/end.png',
                    height: 20,
                    width: 20,
                    color: GlassTheme.textColor('course_set_view')
                        .withValues(alpha: .7)),
                onPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 900), curve: Curves.ease);
                },
              ),
            ],
          ),
          const SizedBox(height: 4),
          Expanded(
              flex: 1,
              child: PageView(
                children: courseTime(),
                controller: _pageController,
                onPageChanged: (int index){
                  if(index==0){
                    setState((){_pageIndex=index+1;});
                    oneStartControllerHours.animateToItem(resDataTime[0].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    oneStartControllerMinutes.animateToItem(resDataTime[0].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    oneEndControllerHours.animateToItem(resDataTime[1].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    oneEndControllerMinutes.animateToItem(resDataTime[1].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }else
                  if(index==1){
                    setState((){_pageIndex=index+1;});
                    twoStartControllerHours.animateToItem(resDataTime[2].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    twoStartControllerMinutes.animateToItem(resDataTime[2].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    twoEndControllerHours.animateToItem(resDataTime[3].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    twoEndControllerMinutes.animateToItem(resDataTime[3].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }
                  else
                  if(index==2){
                    setState((){_pageIndex=index+1;});
                    threeStartControllerHours.animateToItem(resDataTime[4].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    threeStartControllerMinutes.animateToItem(resDataTime[4].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    threeEndControllerHours.animateToItem(resDataTime[5].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    threeEndControllerMinutes.animateToItem(resDataTime[5].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }else
                  if(index==3){
                    setState((){_pageIndex=index+1;});
                    fourStartControllerHours.animateToItem(resDataTime[6].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fourStartControllerMinutes.animateToItem(resDataTime[6].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fourEndControllerHours.animateToItem(resDataTime[7].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fourEndControllerMinutes.animateToItem(resDataTime[7].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }else
                  if(index==4){
                    setState((){_pageIndex=index+1;});
                    fiveStartControllerHours.animateToItem(resDataTime[8].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fiveStartControllerMinutes.animateToItem(resDataTime[8].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fiveEndControllerHours.animateToItem(resDataTime[9].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    fiveEndControllerMinutes.animateToItem(resDataTime[9].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }else
                  if(index==5){
                    setState((){_pageIndex=index+1;});
                    sixStartControllerHours.animateToItem(resDataTime[10].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    sixStartControllerMinutes.animateToItem(resDataTime[10].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    sixEndControllerHours.animateToItem(resDataTime[11].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                    sixEndControllerMinutes.animateToItem(resDataTime[11].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  }

                },
              )),


        /*for( int i =1 ; i <= CourseData.oldCourseTime.length ; ++i){

      CourseData.oldCourseTime[i-1] = '${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}';

    }

    Navigator.pop(context);*/

          Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          backgroundColor:
                              GlassTheme.textColor('course_set_view')
                                  .withValues(alpha: .08),
                          foregroundColor:
                              GlassTheme.textColor('course_set_view')
                                  .withValues(alpha: .8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(23)),
                        ),
                        child: const Text('取消', style: TextStyle(fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GradientButton(
                      text: '确定',
                      page: 'course_set_view',
                      height: 46,
                      onPressed: () {
                        Navigator.pop(context, resDataTime);
                      },
                    ),
                  ),
                ],
              ),

            ),
          )

        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
      oneStartControllerHours.animateToItem(resDataTime[0].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneStartControllerMinutes.animateToItem(resDataTime[0].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneEndControllerHours.animateToItem(resDataTime[1].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneEndControllerMinutes.animateToItem(resDataTime[1].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);

    });


  }
}
