import 'package:flutter/material.dart';
import 'package:nnlg/utils/XiaoBeiHomeUtil.dart';
import 'package:nnlg/view/module/setXiaoBeiPlayTImeSheet.dart';

import '../../utils/ToastUtil.dart';
import '../module/SelectLocation.dart';


class XiaoBei_Home extends StatefulWidget {
  const XiaoBei_Home({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Home> createState() => _XiaoBei_HomeState();
}

class _XiaoBei_HomeState extends State<XiaoBei_Home> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        XiaoBei_Home_Card_2(),
        XiaoBei_Home_Card_1(),
        XiaoBei_Home_Card_3(),
        XiaoBei_Home_Card_4()

      ],
    );
  }
}

//一些功能的开关，比如随机体温开关这些
class XiaoBei_Home_Card_1 extends StatefulWidget {
  const XiaoBei_Home_Card_1({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Home_Card_1> createState() => _XiaoBei_Home_Card_1State();
}

class _XiaoBei_Home_Card_1State extends State<XiaoBei_Home_Card_1> {

  bool _playRandomSwitch = false;
  bool _playSwitch = false;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [

                Container(
                  margin: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: 0),
                  height: MediaQuery.of(context).size.height/5,
                  width: MediaQuery.of(context).size.width/2.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0,7.0),
                            blurRadius: 14.0,
                            spreadRadius: 0,
                            color:Color(0xFFdfdfdf)
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('随机体温开关'),
                      Switch(value: _playRandomSwitch, onChanged: (value){
                        setState((){
                          _playRandomSwitch = value;
                        });
                        setRandomTemperatureSW();
                      })
                    ],
                  ),
                ),


              ],
            ),
            Column(
              children: [

                Container(
                  margin: EdgeInsets.only(
                      left: 0,
                      right: 0,
                      top: 0),
                  height: MediaQuery.of(context).size.height/5,
                  width: MediaQuery.of(context).size.width/2.4,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0,7.0),
                            blurRadius: 14.0,
                            spreadRadius: 0,
                            color:Color(0xFFdfdfdf)
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('自动打卡开关'),
                      Switch(value: _playSwitch, onChanged: (value){
                        setState((){
                          _playSwitch = value;
                        });
                        setAutoPlaySW();
                      })
                    ],
                  ),
                ),


              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    initAutoPlaySW();
    initRandomTemperatureSW();
  }

  //自动打卡开关的初始化的获取与设置
  initAutoPlaySW(){
    XiaoBeiHomeUtil().getAutoPlaySW().then((value){
      int autoSW = value["data"]["healthPlaySwitch"];
      setState((){
        if(autoSW == 0)
          this._playSwitch = false;
        if(autoSW==1)
          this._playSwitch = true;
      });

    });
  }

  //随机体温的初始化的获取与设置
  initRandomTemperatureSW(){
    XiaoBeiHomeUtil().getRandomTemperatureSW().then((value){
      int randomSW = value["data"]["healthTemperatureRandomSwitch"];
      setState((){
        if(randomSW == 0)
          this._playRandomSwitch = false;
        if(randomSW==1)
          this._playRandomSwitch = true;
      });
    });

  }

  setAutoPlaySW(){
    XiaoBeiHomeUtil().setAutoPlaySW(this._playSwitch).then((value){
      if(value["code"]==200){
        ToastUtil.show("${value["msg"]}");
      }else{
        setState((){
          this._playSwitch = !this._playSwitch;
        });
      }
    });
  }

  setRandomTemperatureSW(){
    XiaoBeiHomeUtil().setRandomTemperatuerSW(this._playRandomSwitch).then((value){
      if(value["code"]==200){
        ToastUtil.show("${value["msg"]}");
      }else{
        setState((){
          this._playRandomSwitch = !this._playRandomSwitch;
        });
      }
    });
  }




}


//信息展示--------------------------------
class XiaoBei_Home_Card_2 extends StatefulWidget {
  const XiaoBei_Home_Card_2({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Home_Card_2> createState() => _XiaoBei_Home_Card_2State();
}

_XiaoBei_Home_Card_2State? _xiaoBei_Home_Card_2State;
class _XiaoBei_Home_Card_2State extends State<XiaoBei_Home_Card_2> {

  //累计自动打卡天数
  int autoPlayDayAns = 0;
  //寄存每日自动打卡的时间
  String autoPlayTime = "00:00";
  //打卡地址
  String autoPlayAddress = '中国-广西自治区-桂林市-雁山区-雁山镇-南宁理工学院';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/4,
            width: MediaQuery.of(context).size.width/1.165,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    //打卡天数显示----------------------
                    Column(
                      children: [
                        Text('累计自动打卡天数',style: TextStyle(fontSize: 15),),
                        Text('${autoPlayDayAns}')
                      ],
                    ),
                    //中间用来隔开的线--------------------
                    Container(
                      height: 100,
                      width: 1,
                      color: Colors.black26,
                    ),
                    Column(
                      children: [
                        Text('每日自动打卡时间',style: TextStyle(fontSize: 15),),
                        Text('${autoPlayTime}')
                      ],
                    )



                  ],
                ),
                //分割用的线
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
                  child: Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width/1.5,
                    color: Colors.black26,
                  ),
                ),
                Text('${autoPlayAddress}',style: TextStyle(fontSize: 12,),)
              ],
            ),
          ),

        ),

      ],
    );
  }

  @override
  void initState() {
    _xiaoBei_Home_Card_2State = this;
    initAutoPlayTime();
    initAutoPlayDayAns();
    initAutoPlayAddress();
  }

  refreshUI(){
    setState((){

    });
  }

  //初始化打卡总天数的显示
  initAutoPlayDayAns(){
    XiaoBeiHomeUtil().getAutoPlaySumDays().then((value){
      if(value["code"]==200){
        setState((){
          print('${value}');
          autoPlayDayAns = value["data"];
        });
      }else{
        ToastUtil.show('${value["msg"]}');
      }
    });
  }


  //初始化每日自动打卡的时间
  initAutoPlayTime(){
    XiaoBeiHomeUtil().getEveryDayPlayCardTime().then((value){
      //print('${value}');
      setState((){
        autoPlayTime = value["data"]["healthPlayTime"];
      });
    });
  }

  //初始化打卡地址
  initAutoPlayAddress(){
    XiaoBeiHomeUtil().getPlayCardLocation().then((value){
      print('${value}');
      autoPlayAddress = value["data"]["coordinates"];
    });
  }


}


//每日打卡的打卡位置设定-------------------------------
class XiaoBei_Home_Card_3 extends StatefulWidget {
  const XiaoBei_Home_Card_3({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Home_Card_3> createState() => _XiaoBei_Home_Card_3State();
}

class _XiaoBei_Home_Card_3State extends State<XiaoBei_Home_Card_3> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(28, 10, 0, 0),
              child: Container(
                margin: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0),
                height: MediaQuery.of(context).size.height/6,
                width: MediaQuery.of(context).size.width/2.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0,7.0),
                          blurRadius: 14.0,
                          spreadRadius: 0,
                          color:Color(0xFFdfdfdf)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('修改定位'),
                  ],
                ),
              ),
            ),
          ),
          onTap: () async {

            setPlayCardLocation();

          },
        ),
        InkWell(
          child: Container(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Container(
                margin: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 0),
                height: MediaQuery.of(context).size.height/6,
                width: MediaQuery.of(context).size.width/2.4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0.0,7.0),
                          blurRadius: 14.0,
                          spreadRadius: 0,
                          color:Color(0xFFdfdfdf)
                      )
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('修改每日打卡时间'),
                  ],
                ),
              ),
            ),
          ),
          onTap: (){
            setXiaoBeiPlayTimeSheet sxbpts = setXiaoBeiPlayTimeSheet(context);
            sxbpts.show().then((value){

              if(value!=null){
                TimeOfDay setTIme = value as TimeOfDay;
                setXiaoBeiPlayTime(setTIme);

              }
            });

          },
        )
      ],
    );
  }


  setXiaoBeiPlayTime(TimeOfDay timeOfDay){
    String timeStr = '${timeOfDay.hour.toString().padLeft(2,'0')}:${timeOfDay.minute.toString().padLeft(2,'0')}';
    XiaoBeiHomeUtil().setEveryDayPlayCardTime(timeStr).then((value){
      print('${value}');
      if(value["code"]==200){
        ToastUtil.show('${value["msg"]}');
        _xiaoBei_Home_Card_2State?.autoPlayTime = timeStr;
        _xiaoBei_Home_Card_2State?.refreshUI();
        return;
      }
      ToastUtil.show('${value["msg"]}');
    });
  }

  setPlayCardLocation() async {

    List reslut = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return SelectLocation();
    }));
    print('${reslut.toString()}');

    if(reslut!=null){
      XiaoBeiHomeUtil().setPlayCardLocation('${reslut[1]},${reslut[2]}', '${reslut[0]}').then((value){
        if(value["code"]==200){
          _xiaoBei_Home_Card_2State?.autoPlayAddress=reslut[0].toString();
          _xiaoBei_Home_Card_2State?.refreshUI();
          ToastUtil.show('${value["msg"]}');
        }
      });
    }


  }




}


/**
 * 一键手动打卡
 */
class XiaoBei_Home_Card_4 extends StatefulWidget {
  const XiaoBei_Home_Card_4({Key? key}) : super(key: key);

  @override
  State<XiaoBei_Home_Card_4> createState() => _XiaoBei_Home_Card_4State();
}

class _XiaoBei_Home_Card_4State extends State<XiaoBei_Home_Card_4> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(28, 10, 28, 0),
          child: Container(
            margin: EdgeInsets.only(
                left: 0,
                right: 0,
                top: 0),
            height: MediaQuery.of(context).size.height/6,
            width: MediaQuery.of(context).size.width/2.4,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0,7.0),
                      blurRadius: 14.0,
                      spreadRadius: 0,
                      color:Color(0xFFdfdfdf)
                  )
                ]
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('一键手动打卡'),
              ],
            ),
          ),
        ),
      ),
      onTap: (){
        actionPlayOneCard();
      },
    );
  }
  
  
  
  actionPlayOneCard(){
    ToastUtil.show('等待打卡系统反馈...');
    XiaoBeiHomeUtil().setPlayOneCard().then((value){
      if(value["code"]==200){
        ToastUtil.show('${value['data']['msg']}');
      }else{
        ToastUtil.show('${value['msg']}');
      }

    });
  }
  
  
}



