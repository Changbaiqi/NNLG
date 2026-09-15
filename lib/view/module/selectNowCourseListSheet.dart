
import 'package:flutter/material.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/GlassUI.dart';

/*
 * [author] 长白崎
 * [date] 2024/2/10 21:37
 * [description] TODO 用于选择本学期的课表的组件
 */
class selectNowCourseListSheet{

  dynamic _context;

  selectNowCourseListSheet(context){
    _context = context;
  }


  Future show(){

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: .35),
        isScrollControlled: true,
        context: _context,
        builder: (builder){
          return GlassCard(
            page: 'course_set_view',
            padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: selectNowCourseListSheetMain(),
          );
        });
  }

}



class selectNowCourseListSheetMain extends StatefulWidget {
  const selectNowCourseListSheetMain({Key? key}) : super(key: key);

  @override
  State<selectNowCourseListSheetMain> createState() => _selectNowCourseListSheetMainState();
}

class _selectNowCourseListSheetMainState extends State<selectNowCourseListSheetMain> {

  List<Widget> _widgetList= [];

  int _resNowChoosewidget  = 0;


  void loadingWidgetList(){

    for(int i =0 ; i < CourseData.semesterCourseList.length ; ++i){
      _widgetList.add(Text("${CourseData.semesterCourseList[i]}",
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: GlassTheme.textColor('course_set_view'))));
    }


  }


  int getIndex(String semester){

    for(int i =0 ; i < CourseData.semesterCourseList.length ; ++i){
      if(CourseData.semesterCourseList[i] == semester){
        return i;
      }
    }

    return 0;
  }





  FixedExtentScrollController _chooseController = new FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {
    final Color textColor = GlassTheme.textColor('course_set_view');
    return SizedBox(
      height: 330,
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
                '学期课表',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                CourseData.semesterCourseList.length > _resNowChoosewidget
                    ? '${CourseData.semesterCourseList[_resNowChoosewidget]}'
                    : '${CourseData.nowCourseList.value}',
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withValues(alpha: .6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Expanded(
              child: ListWheelScrollView(
                itemExtent: 46,
                useMagnifier: true,
                magnification: 1.35,
                controller: _chooseController,
                onSelectedItemChanged: (index) {
                  setState(() {
                    _resNowChoosewidget = index;
                  });
                }, children: _widgetList,),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: textColor.withValues(alpha: .08),
                      foregroundColor: textColor.withValues(alpha: .8),
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
                    if (CourseData.semesterCourseList.length >
                        _resNowChoosewidget) {
                      Navigator.pop(context,
                          '${CourseData.semesterCourseList[_resNowChoosewidget]}');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          )
        ],

      ),
    );
  }





  @override
  void initState() {
    loadingWidgetList();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
          _resNowChoosewidget = getIndex(CourseData.nowCourseList.value);
          _chooseController.animateToItem( _resNowChoosewidget, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
          setState(() {});
    });
    
  }



}
