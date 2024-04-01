import 'package:flutter/material.dart';


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
        child: Text('假期中'),
    )
    );
    for(int i = 1 ; i <= num ; ++i ){
      Widget choseWidget = Container(
        height: 100,
        alignment: Alignment.center,
        child: Text('${i}'),
      );
      weekList.add(choseWidget);
    }



    return showModalBottomSheet(context: _context, builder: (builder) {
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