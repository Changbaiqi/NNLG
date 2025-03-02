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
    //
    return Container(
      height: 50,
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Column(
            children: [
              Center(child: Text('上课时间',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),),
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

                              resDataTime[_pageIndex.value*2-2] = DateTime(0,0,0,index,resDataTime[_pageIndex.value*2-2].minute);
                              // debugPrint('${resDataTime[_pageIndex.value*2-2].hour}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: hourWidget(),
                          )),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('时',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),)),
                      Container(
                          width:60,
                          child: Center(child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: startControllerMinutes,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex.value*2-2] = DateTime(0,0,0,resDataTime[_pageIndex.value*2-2].hour,index);
                              // debugPrint('${resDataTime[_pageIndex.value*2-2].minute}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: minuteWidget(),
                          ),)),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('分',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),)),
                    ],
                  ))

            ],
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Container(height: MediaQuery.of(_context).size.height/7,width: 1,color: Colors.black45,),Text('至'),Container(height: MediaQuery.of(_context).size.height/7,width: 1,color: Colors.black45)],),
          ),
          Column(

            children: [
              Center(child: Text('下课时间',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),),
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

                              resDataTime[_pageIndex.value*2-1] = DateTime(0,0,0,index,resDataTime[_pageIndex.value*2-1].minute);
                              // debugPrint('${resDataTime[_pageIndex.value*2-1].hour}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: hourWidget(),
                          )),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('时',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),)),
                      Container(
                          width:60,
                          child: Center(child: ListWheelScrollView(
                            itemExtent: 60,
                            useMagnifier: true,
                            magnification: 1.5,
                            controller: endControllerMinutes,
                            onSelectedItemChanged: (index) {

                              resDataTime[_pageIndex.value*2-1] = DateTime(0,0,0,resDataTime[_pageIndex.value*2-1].hour,index);
                              // debugPrint('${resDataTime[_pageIndex.value*2-1].minute}');

                            },
                            physics: FixedExtentScrollPhysics(
                                parent: BouncingScrollPhysics()
                            ),

                            children: minuteWidget(),
                          ),)),
                      Container(
                          width:10,
                          child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 0,60),child: Text('分',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),),))


                    ],
                  ))

            ],
          )


        ],
      ),
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
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['backgroundColor'] as List )
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            decoration: BoxDecoration(
                // color: Color.fromARGB(255, 241, 241, 241),
              color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['backgroundColor'] as List ),
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
                IconButton(icon: Image.asset('assets/images/start.png',height: 25,width: 25,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['defaultIconColor'] as List ),),onPressed: (){ _pageController.previousPage(duration: Duration(milliseconds: 900), curve: Curves.ease); },),
                Obx(() => Text('第${_pageIndex.value}小节',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['textColor'] as List )),)),
                //下一页
                IconButton(icon: Image.asset('assets/images/end.png',height: 25,width: 25,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['course_set_view']!['defaultIconColor'] as List ),),onPressed: (){   _pageController.nextPage(duration: Duration(milliseconds: 900), curve: Curves.ease); },),
              ],
            ),
          ),
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

                  Container(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(_context);
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

                        Navigator.pop(_context, resDataTime);

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

  static Future show(_context,int _sum,List<String> initTimeString){

    return showModalBottomSheet(
      context: _context,
      builder: (builder){
        return Container(
          child: selectCourseTimeSheet(_context,_sum,initTimeString).build(),
        );
      }
    );
  }
}

