import 'package:flutter/material.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/GlassUI.dart';


/*
 * [author] 长白崎
 * [date] 2024/2/10 21:36
 * [description] 用于选择开学时间的组件
 */
class selectDateSheet {




  dynamic _context;

  selectDateSheet(context){
    _context = context;
  }


  Future show() async {


    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: .35),
        isScrollControlled: true,
        context: _context,
        builder: (builder) {
          return GlassCard(
            page: 'course_set_view',
            padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: selectDateSheetMain(),
          );
        });
  }




}








class selectDateSheetMain extends StatefulWidget {
  const selectDateSheetMain({Key? key}) : super(key: key);

  @override
  State<selectDateSheetMain> createState() => _selectDateSheetMainState();
}

class _selectDateSheetMainState extends State<selectDateSheetMain> {



  List<String> _year = [];

  List<String> _month = [];

  List<String> _days = [];

  int _chooseYear = DateTime.now().year-20;
  int _chooseMonth = 1;
  int _chooseDay = 1;





  List<Widget> updateYear(){


    List<Widget> yearWidget = <Widget>[];
    _year.clear();
    for(int i = DateTime.now().year-20 ; i <= (DateTime.now().year)+4 ; ++i ){
      Widget choseWidget = Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('${i}',style: TextStyle(fontSize: 17,color: GlassTheme.textColor('course_set_view'))),
      );
      _year.add('${i}');
      yearWidget.add(choseWidget);
    }

    return yearWidget;

  }

  List<Widget> updateMonth(){

    List<Widget> monthWidget = <Widget>[];
    _month.clear();
    for(int i = 1 ; i <= 12 ; ++i ){
      Widget choseWidget = Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('${i}',style: TextStyle(fontSize: 17,color: GlassTheme.textColor('course_set_view'))),
      );
      _month.add('${i}');
      monthWidget.add(choseWidget);
    }

    return monthWidget;

  }


  List<Widget> updateDays(){

    DateTime nowDateTime = DateTime(_chooseYear,_chooseMonth);
    int ansDays = DateTime(nowDateTime.year,nowDateTime.month+1).toUtc().difference(nowDateTime).inDays;
    //print(ansDays);

    List<Widget> daysWidget = <Widget>[];
    _days.clear();
    for(int i = 1 ; i <= ansDays ; ++i ){
      Widget choseWidget = Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('${i}',style: TextStyle(fontSize: 17,color: GlassTheme.textColor('course_set_view'))),
      );
      _days.add('${i}');
      daysWidget.add(choseWidget);
    }

    return daysWidget;

  }

  FixedExtentScrollController yearController = FixedExtentScrollController();
  FixedExtentScrollController monthController = FixedExtentScrollController();
  FixedExtentScrollController dayController = FixedExtentScrollController();


  @override
  Widget build(BuildContext context) {
    final Color textColor = GlassTheme.textColor('course_set_view');
    return SizedBox(
      height: 330,
      child: StatefulBuilder(builder: (_context, state){


            return Column(
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
                      '开学时间',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_chooseYear}/${_chooseMonth}/${_chooseDay}',
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor.withValues(alpha: .6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: ListWheelScrollView(
                          itemExtent: 46,
                          useMagnifier: true,
                          magnification: 1.35,
                          controller: yearController,
                          onSelectedItemChanged: (index) {
                            _chooseYear =index+DateTime.now().year-20;
                            state((){
                              updateDays();
                            });
                            //setDialogState((){});
                          },
                          physics: FixedExtentScrollPhysics(
                              parent: BouncingScrollPhysics()
                          ),

                          children: updateYear(),
                        )),
                    Expanded(
                        flex: 1,
                        child: ListWheelScrollView(
                          itemExtent: 46,
                          useMagnifier: true,
                          magnification: 1.35,
                          controller: monthController,
                          onSelectedItemChanged: (index) {
                            _chooseMonth = index+1;
                            state((){
                              updateDays();
                            });
                          },
                          physics: FixedExtentScrollPhysics(
                              parent: BouncingScrollPhysics()
                          ),

                          children: updateMonth(),
                        )),
                    Expanded(
                        flex: 1,
                        child: ListWheelScrollView(
                          itemExtent: 46,
                          useMagnifier: true,
                          magnification: 1.35,
                          controller: dayController,
                          onSelectedItemChanged: (index) {
                            _chooseDay = index+1;

                            state((){
                              updateDays();
                            });

                          },
                          physics: FixedExtentScrollPhysics(
                              parent: BouncingScrollPhysics()
                          ),

                          children: updateDays(),
                        ))


                  ],
                ),
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
                          child:
                              const Text('取消', style: TextStyle(fontSize: 15)),
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
                          Navigator.pop(context,
                              '${_chooseYear}/${_chooseMonth}/${_chooseDay}');
                        },
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
    );

  }



  void initListWheelChoose(){

    int _resnowYear = 0;
    int _resnowMonth = 0;
    int _resnowDay = 0;

    for( int i = 0 ; i < _year.length ; ++i ){
      if( CourseData.schoolOpenTime.value.split("/")[0] == _year[i] ){
        _resnowYear = i;
      }
    }

    for( int i = 0 ; i < _month.length ; ++i ){
      if( CourseData.schoolOpenTime.value.split("/")[1] == _month[i] ){
        _resnowMonth = i;
      }
    }

    for( int i = 0 ; i < _days.length ; ++i ){
      if( CourseData.schoolOpenTime.value.split("/")[2] == _days[i] ){
        _resnowDay = i;
      }
    }

    yearController.animateToItem(_resnowYear, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    monthController.animateToItem(_resnowMonth, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    dayController.animateToItem(_resnowDay, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);


  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initListWheelChoose();
    });
  }




}
