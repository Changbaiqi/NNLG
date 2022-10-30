import 'package:flutter/material.dart';
import 'package:nnlg/view/XiaoBei_qingjia.dart';

class XiaoBeiLeave extends StatefulWidget {
  const XiaoBeiLeave({Key? key}) : super(key: key);

  @override
  State<XiaoBeiLeave> createState() => _XiaoBeiLeaveState();
}

class _XiaoBeiLeaveState extends State<XiaoBeiLeave> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: XiaoBei_gzt(),
    );
  }
}

class XiaoBei_gzt extends StatefulWidget {
  const XiaoBei_gzt({Key? key}) : super(key: key);

  @override
  State<XiaoBei_gzt> createState() => _XiaoBei_gztState();
}

class _XiaoBei_gztState extends State<XiaoBei_gzt> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset('images/xiaobei_gzt.jpg',fit: BoxFit.fill,height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                  flex: 12,
                  child: Container(
                    //color: Color.fromARGB(150, 100, 0, 0),
                    child: Row(
                      children: [

                      ],
                    ),
                  )),
              Expanded(
                  flex: 55,
                  child: Container(
                    //color: Color.fromARGB(150, 0, 50, 0),
                    child: GridView.count(
                        crossAxisCount: 2,
                      childAspectRatio: 10/4,
                      children: [
                        InkWell(
                          onTap: (){
                            print('请假');
                            Navigator.push(context, MaterialPageRoute(builder: (builder){
                              return XiaoBei_qingjia();
                            }));
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('销假');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('查寝');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('活动签到');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('信息收集');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('学生信息');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('学生信箱');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('体温上报统计');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('体温上报');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('综合测评');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('评奖评优');
                          },
                        ),
                        InkWell(
                          onTap: (){
                            print('身份码');
                          },
                        )

                      ],
                    ),
                  )),
              Expanded(
                  flex: 7,
                  child: Container(
                    //color: Color.fromARGB(150, 0, 0, 50),
                  ))
            ],
          )
        ],
      ),
    );
  }
}

