/* FileName selectCourseTimeSheet
 *
 * @Author 20840
 * @Date 2024/7/17 20:17
 *
 * @Description TODO
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/GlassUI.dart';

class selectCourseTimeSheet{
  final _context;
  final _sum;
  List startControllerHours = [].obs;
  List startControllerMinutes = [].obs;
  List endControllerHours = [].obs;
  List endControllerMinutes = [].obs;
  List<DateTime> resDataTime = [];
  final _pageIndex = 1.obs;//用来指示上面的大节标签
  PageController _pageController = PageController(
    initialPage: 0,
  );

  selectCourseTimeSheet(this._context,this._sum,List<String> initTimeString){
    for(int i =0 ;i<_sum;++i){
      startControllerHours.add(FixedExtentScrollController());
      startControllerMinutes.add(FixedExtentScrollController());
      endControllerHours.add(FixedExtentScrollController());
      endControllerMinutes.add(FixedExtentScrollController());

      List<String> start = (initTimeString[i].split("-")[0]).split(":");
      List<String> end = (initTimeString[i].split("-")[1]).split(":");
      resDataTime.add(DateTime(0,0,0, int.parse(start[0]),int.parse(start[1])) );
      resDataTime.add(DateTime(0,0,0, int.parse(end[0]),int.parse(end[1])) );
    }
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
      //print('加载完界面');
      startControllerHours[0].animateToItem(resDataTime[0].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      startControllerMinutes[0].animateToItem(resDataTime[0].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      endControllerHours[0].animateToItem(resDataTime[1].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      endControllerMinutes[0].animateToItem(resDataTime[1].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);

    });
  }

  //构建小时时间控件
  List<Widget> hourWidget(){
    List<Widget> hoursList = [];

    for(int i = 0 ; i < 24 ; ++i){
      hoursList.add(Text('${i.toString().padLeft(2,'0')}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),));
    }

    return hoursList;
  }
  //构建分钟时间控件
  List<Widget> minuteWidget(){
    List<Widget> hoursList = [];

    for(int i = 0 ; i < 60 ; ++i){
      hoursList.add(Text('${i.toString().padLeft(2,'0')}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),));
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
              resDataTime[_pageIndex.value * 2 - 2] = DateTime(
                  0, 0, 0, index, resDataTime[_pageIndex.value * 2 - 2].minute);
            },
            onMinute: (index) {
              resDataTime[_pageIndex.value * 2 - 2] = DateTime(
                  0, 0, 0, resDataTime[_pageIndex.value * 2 - 2].hour, index);
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
              resDataTime[_pageIndex.value * 2 - 1] = DateTime(
                  0, 0, 0, index, resDataTime[_pageIndex.value * 2 - 1].minute);
            },
            onMinute: (index) {
              resDataTime[_pageIndex.value * 2 - 1] = DateTime(
                  0, 0, 0, resDataTime[_pageIndex.value * 2 - 1].hour, index);
            },
            textColor: textColor,
          )),
        ],
      ),
    );
  }

  //单个时间选择列（大节/小节通用）
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

  List<Widget> courseTimeList(){
    List<Widget> list = [];
    for(int i =0 ;i<_sum;++i){
      list.add(chooseWidget(startControllerHours[i], startControllerMinutes[i], endControllerHours[i], endControllerMinutes[i]));
    }
    return list;
  }



  Widget build(){
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
                '各小节课时间',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: GlassTheme.textColor('course_set_view'),
                ),
              ),
              const Spacer(),
              Obx(() => Text(
                    '第 ${_pageIndex.value} 小节',
                    style: TextStyle(
                      fontSize: 13,
                      color: GlassTheme.textColor('course_set_view')
                          .withValues(alpha: .6),
                    ),
                  )),
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
                children: courseTimeList(),
                controller: _pageController,
                onPageChanged: (int index){
                  _pageIndex.value = index+1;
                  startControllerHours[index].animateToItem(resDataTime[index*2].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  startControllerMinutes[index].animateToItem(resDataTime[index*2].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  endControllerHours[index].animateToItem(resDataTime[index*2+1].hour, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
                  endControllerMinutes[index].animateToItem(resDataTime[index*2+1].minute, duration: Duration(milliseconds: 300), curve: Curves.easeInOutQuart);
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
              width: MediaQuery.of(_context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(_context);
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
                        Navigator.pop(_context, resDataTime);
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

  static Future show(_context,int _sum,List<String> initTimeString){

    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .35),
      isScrollControlled: true,
      context: _context,
      builder: (builder){
        return GlassCard(
          page: 'course_set_view',
          padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: selectCourseTimeSheet(_context,_sum,initTimeString).build(),
        );
      }
    );
  }
}

