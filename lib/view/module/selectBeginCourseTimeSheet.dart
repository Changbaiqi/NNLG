
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/WeekDayForm.dart';

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
        context: _context,
        builder: (builder){
          return Ceshi();
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
    List<String> oneStart = (CourseData.courseTime[0].split("-")[0]).split(":");
    List<String> oneEnd = (CourseData.courseTime[0].split("-")[1]).split(":");

    List<String> twoStart = (CourseData.courseTime[1].split("-")[0]).split(":");
    List<String> twoEnd = (CourseData.courseTime[1].split("-")[1]).split(":");

    List<String> threeStart = (CourseData.courseTime[2].split("-")[0]).split(":");
    List<String> threeEnd = (CourseData.courseTime[2].split("-")[1]).split(":");

    List<String> fourStart = (CourseData.courseTime[3].split("-")[0]).split(":");
    List<String> fourEnd = (CourseData.courseTime[3].split("-")[1]).split(":");

    List<String> fiveStart = (CourseData.courseTime[4].split("-")[0]).split(":");
    List<String> fiveEnd = (CourseData.courseTime[4].split("-")[1]).split(":");

    List<String> sixStart = (CourseData.courseTime[5].split("-")[0]).split(":");
    List<String> sixEnd = (CourseData.courseTime[5].split("-")[1]).split(":");

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
      hoursList.add(Text('${i.toString().padLeft(2,'0')}'));
    }

    return hoursList;
  }

  List<Widget> minuteWidget(){
    List<Widget> hoursList = [];

    for(int i = 0 ; i < 60 ; ++i){
      hoursList.add(Text('${i.toString().padLeft(2,'0')}'));
    }

    return hoursList;
  }

  Widget chooseWidget(FixedExtentScrollController startControllerHours,FixedExtentScrollController startControllerMinutes,
                      FixedExtentScrollController endControllerHours,FixedExtentScrollController endControllerMinutes ){
    //
    return Container(
      height: 50,
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Column(
            children: [
              Center(child: Text('上课时间'),),
              Expanded(
                flex: 1,
                  child: Row(
                    children: [
                      Container(
                          width:60,
                          child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: startControllerHours,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex*2-2] = DateTime(0,0,0,index,resDataTime[_pageIndex*2-2].minute);
                              debugPrint('${resDataTime[_pageIndex*2-2].hour}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: hourWidget(),
                          )),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('时'),)),
                      Container(
                          width:60,
                          child: Center(child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: startControllerMinutes,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex*2-2] = DateTime(0,0,0,resDataTime[_pageIndex*2-2].hour,index);
                              debugPrint('${resDataTime[_pageIndex*2-2].minute}');

                              },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: minuteWidget(),
                          ),)),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('分'),)),
                    ],
              ))

            ],
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(height: MediaQuery.of(context).size.height/7,width: 1,color: Colors.black45,),Text('至'),Container(height: MediaQuery.of(context).size.height/7,width: 1,color: Colors.black45)],),
          ),
          Column(

            children: [
              Center(child: Text('下课时间'),),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [


                      Container(
                          width:60,
                          child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: endControllerHours,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex*2-1] = DateTime(0,0,0,index,resDataTime[_pageIndex*2-1].minute);
                              debugPrint('${resDataTime[_pageIndex*2-1].hour}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: hourWidget(),
                          )),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('时'),)),
                      Container(
                          width:60,
                          child: Center(child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: endControllerMinutes,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex*2-1] = DateTime(0,0,0,resDataTime[_pageIndex*2-1].hour,index);
                              debugPrint('${resDataTime[_pageIndex*2-1].minute}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: minuteWidget(),
                          ),)),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('分'),))


                    ],
                  ))

            ],
          )


        ],
      ),
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
    return Container(
      height: 400,
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 241, 241, 241),
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,blurRadius: 10,offset: Offset(1,1)
                )
              ]
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //上一页
                IconButton(icon: Image.asset('assets/images/start.png',height: 25,width: 25,color: Colors.black54,),onPressed: (){ _pageController.previousPage(duration: Duration(milliseconds: 900), curve: Curves.ease); },),
                Text('第${WeekDayForm.Chinese(_pageIndex)}大节'),
                //下一页
                IconButton(icon: Image.asset('assets/images/end.png',height: 25,width: 25,color: Colors.black54,),onPressed: (){   _pageController.nextPage(duration: Duration(milliseconds: 900), curve: Curves.ease); },),
              ],
            ),
          ),
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


        /*for( int i =1 ; i <= CourseData.courseTime.length ; ++i){

      CourseData.courseTime[i-1] = '${(resDataTime[i*2-2].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-2].minute.toString()).padLeft(2,'0')}-${(resDataTime[i*2-1].hour.toString()).padLeft(2,'0')}:${(resDataTime[i*2-1].minute.toString()).padLeft(2,'0')}';

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



                        Navigator.pop(context, resDataTime);



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

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
      //print('加载完界面');
      oneStartControllerHours.animateToItem(resDataTime[0].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneStartControllerMinutes.animateToItem(resDataTime[0].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneEndControllerHours.animateToItem(resDataTime[1].hour, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
      oneEndControllerMinutes.animateToItem(resDataTime[1].minute, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);

    });


  }
}
