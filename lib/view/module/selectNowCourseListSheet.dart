
import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';

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
        context: _context,
        builder: (builder){
          return selectNowCourseListSheetMain();
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
      _widgetList.add(Text("${CourseData.semesterCourseList[i]}"));
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
    return Container(
      height: 350,
      child: Column(
        children: [

          Expanded(
              flex: 1,
              child: Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListWheelScrollView(
                  itemExtent: 60,
                  useMagnifier: true,
                  magnification: 1.5,
                  controller: _chooseController,
                  onSelectedItemChanged: (index) {

                    _resNowChoosewidget = index;

                  }, children: _widgetList,),
              )),

          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
            child: Container(
              height: 50,
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
                         Navigator.pop(context, '${CourseData.semesterCourseList[_resNowChoosewidget]}');
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
    loadingWidgetList();
    WidgetsBinding.instance
        .addPostFrameCallback((timeStamp) {
          _resNowChoosewidget = getIndex(CourseData.nowCourseList.value);
          _chooseController.animateToItem( _resNowChoosewidget, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);
    });
    
  }



}
