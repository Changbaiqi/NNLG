import 'package:flutter/material.dart';
import 'package:nnlg/dao/CourseData.dart';

/*
 * [author] 长白崎
 * [date] 2024/2/10 21:38
 * [description] TODO 本学期总周数选择
 */
class showCourseNumSheet{


  dynamic _context;

   showCourseNumSheet(context){
     _context = context;
  }

  Future show() async {

     return showModalBottomSheet(context: _context, builder: (builder) {

      return showCourseNumSheetMain();

    });


  }



}




class showCourseNumSheetMain extends StatefulWidget {
  const showCourseNumSheetMain({Key? key}) : super(key: key);

  @override
  State<showCourseNumSheetMain> createState() => _showCourseNumSheetMainState();
}

class _showCourseNumSheetMainState extends State<showCourseNumSheetMain> {

  int _index = 0;
  List<int> _courseList=[];



  List<Widget> updateCourseListWidget(){

    List<Widget> courseListWidget = [];
    _courseList.clear();
    for( int i = 17 ; i <= 30 ; ++i ){
      _courseList.add(i);
      Widget chooseWidget = Container(
        child: Center(child: Text('${i}'),),
      );
      courseListWidget.add(chooseWidget);
    }

    return courseListWidget;
  }




  FixedExtentScrollController _controller = FixedExtentScrollController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
          Container(
            height: 200,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListWheelScrollView(
                itemExtent: 60,
                useMagnifier: true,
                magnification: 1.5,
                controller: _controller,
                onSelectedItemChanged: (index){
                  _index = index;
                },
                physics: FixedExtentScrollPhysics(
                    parent: BouncingScrollPhysics()
                ),

                children: updateCourseListWidget(),
              ),
            ),
          ),

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
                        Navigator.pop(context, _index + 17);
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


  initCourseNumChoose(){

    _controller.animateToItem(CourseData.ansWeek.value-17, duration: Duration(milliseconds: 500), curve: Curves.easeInOutQuart);

  }


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initCourseNumChoose();
    });
  }


}

