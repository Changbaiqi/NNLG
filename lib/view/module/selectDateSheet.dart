import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';


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
        context: _context,
        isScrollControlled: true,
        builder: (builder) {
          return selectDateSheetMain();
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
        child: Text('${i}'),
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
        child: Text('${i}'),
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
        child: Text('${i}'),
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



    return Container(
      height: 300,
      child: Column(
        children: [
          StatefulBuilder(builder: (_context,state){


            return Container(
              height: 200,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: ListWheelScrollView(
                          itemExtent: 60,
                          useMagnifier: true,
                          magnification: 1.5,
                          controller: yearController,
                          onSelectedItemChanged: (index) {
                            _chooseYear =index+DateTime.now().year-20;
                            state((){
                              print('刷新');
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
                          itemExtent: 60,
                          useMagnifier: true,
                          magnification: 1.5,
                          controller: monthController,
                          onSelectedItemChanged: (index) {
                            _chooseMonth = index+1;
                            state((){
                              print('刷新');
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
                          itemExtent: 60,
                          useMagnifier: true,
                          magnification: 1.5,
                          controller: dayController,
                          onSelectedItemChanged: (index) {
                            _chooseDay = index+1;

                            state((){
                              print('刷新');
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
            );
          }),

          Center(
            child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('取消',style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.black45
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50))),

                            )
                        )
                    ),

                  ),
                  Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(child: Text('确定',style: TextStyle(color: Colors.black54),),
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))
                          )
                      ),
                      onPressed: () {
                        Navigator.pop(context, '${_chooseYear}/${_chooseMonth}/${_chooseDay}');
                      },),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
