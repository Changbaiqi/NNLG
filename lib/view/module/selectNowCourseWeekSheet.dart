import 'package:flutter/material.dart';
import 'package:callo/utils/GlassUI.dart';


class selectNowCourseWeekSheet{

  dynamic _context;
  int _index=0;

  selectNowCourseWeekSheet(context){
    _context = context;
  }






  Future show(int num) async {

    List<Widget> weekList = [
    ];
    weekList.add(
      Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('假期中',style: TextStyle(fontSize: 17,color: GlassTheme.textColor('course_set_view'))),
    )
    );
    for(int i = 1 ; i <= num ; ++i ){
      Widget choseWidget = Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('${i}',style: TextStyle(fontSize: 17,color: GlassTheme.textColor('course_set_view'))),
      );
      weekList.add(choseWidget);
    }



    return showModalBottomSheet(context: _context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: .35),
        isScrollControlled: true, builder: (builder) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: GlassTheme.pageBackground('course_set_view'),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
        ),
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
                  onSelectedItemChanged: (index) {
                    _index = index;
                  },
                  physics: FixedExtentScrollPhysics(
                      parent: BouncingScrollPhysics()
                  ),

                  children: weekList,
                ),
              ),
            ),

            Center(
              child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(_context);
                          },
                          child: Text('取消',style: TextStyle(color: GlassTheme.scheme.onSurface),),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  GlassTheme.scheme.surfaceContainerHighest
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
                      child: ElevatedButton(child: Text('确定',style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(GlassTheme.accentColor('course_set_view')),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(50)))
                          )
                        ),
                        onPressed: () {
                        Navigator.pop(_context, _index + 1);
                      },),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    });
  }





}