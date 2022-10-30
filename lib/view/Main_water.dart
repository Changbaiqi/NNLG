import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';

import '../dao/WaterData.dart';
import '../utils/ToastUtil.dart';
import '../utils/WaterUtil.dart';
import 'ScanQR_Water.dart';
import 'WaterCharge.dart';
/*import 'package:fluttertoast/fluttertoast.dart';
import 'package:nnzs/ScanQR_Water.dart';
import 'package:nnzs/model/ContextDate.dart';
import 'package:nnzs/model/ShopList.dart';
import 'package:nnzs/utils/SharedDateUtil.dart';
import 'package:nnzs/utils/ToastUtil.dart';
import 'package:nnzs/utils/WaterUtil.dart';*/

class Main_water extends StatefulWidget {
  const Main_water({Key? key}) : super(key: key);

  @override
  State<Main_water> createState() => _Main_waterState();
}

Home_water_Message? home_water_message;
Widget? shopList;
class _Main_waterState extends State<Main_water> {

  Future<void> _onRefresh() async {


      await WaterUtil().getMenoy(WaterData.waterAccount, WaterData.waterSaler).then((value){
        //刷新信息
        home_water_messageState?.updateMessage(money: value);

      });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('打水'),
      ),
      endDrawer: Drawer(
        width: 200,
        child: shopList??Center(child: Text('加载中...'),)),
      body: RefreshIndicator(
        child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context,index){
              return Column(
            children: [
              home_water_message=Home_water_Message(),
              Water_SW()
            ],
          );
            }),
        onRefresh: _onRefresh,
      ),
    );
  }

  @override
  void initState() {
    //shopList = ShopList().getList();
  }

  void getShopList(){

  }



}



class Home_water_Message extends StatefulWidget {
  const Home_water_Message({Key? key}) : super(key: key);


  @override
  State<Home_water_Message> createState() => Home_water_MessageState();


}


Home_water_MessageState? home_water_messageState;
class Home_water_MessageState extends State<Home_water_Message> {

  String? _money;
  String? _divice;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: MediaQuery.of(context).size.width,
      child: Card(
        child: Column(
          children: [
            Text('${(this._money==""||this._money==null)?"0.00":this._money}￥',style: TextStyle(fontSize: 50,color: Colors.orange),),
            Text('当前所选设备编号：${this._divice??"未知"}')
          ],
        ),
      ),
    );
  }

  updateMessage({money,divice}){
    setState((){
      this._money=money;
      this._divice = divice;
    });
  }

  @override
  void initState() {
    home_water_messageState = this;
    WaterUtil().getMenoy(WaterData.waterAccount, WaterData.waterSaler).then((value){
      setState((){
        _money = value;
      });
    });
  }

}



class Water_SW extends StatefulWidget {
  const Water_SW({Key? key}) : super(key: key);

  @override
  State<Water_SW> createState() => _Water_SWState();
}

class _Water_SWState extends State<Water_SW> {



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 539,
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: this._coolWaterSw(),),
                Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: this._hostWaterSw(),),
                Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: this._bingWater(),),

              ],
            ),
          ),
          Card(
            child: Padding(padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: this._bingAccount(),),
          )
        ],
      ),
    );



  }




  Widget _coolWaterSw(){


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('开'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150)
                    )
                )
            ),
            onPressed: () {
              _coolOpenWaterButtonCheck();
            },
          ),),
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('关'),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150)
                    )
                )
            ),
            onPressed: () {
              _coolCloseWaterButtonCheck();
            },
          ),)

      ],
    );


  }


  Widget _hostWaterSw(){


    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('开'),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.pink
              ),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150),
                    )
                )
            ),
            onPressed: () {
              _hotOpenWaterButtonCheck();
            },
          ),),
        Container(
          height: 150,
          width: 150,
          child: ElevatedButton(
            child: Text('关'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.pink
                ),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(150)
                    )
                )
            ),
            onPressed: () {
              _hotCloseWaterButtonCheck();
            },
          ),)

      ],
    );


  }


  //用于冷水打卡
  _coolOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.coolWater, WaterData.cardNum, WaterData.waterAccount).then((value){
          ToastUtil.show('${value['message']}');
        });

      }
      else
        ToastUtil.show('请先绑定机器');
    }
    else
      ToastUtil.show('请先绑定账号');
  }

  //用于冷水关闭
  _coolCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.coolWater, WaterData.cardNum, WaterData.waterAccount).then((value){
          ToastUtil.show('${value['message']}');
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount, WaterData.waterSaler).then((value){
              //刷新信息
              home_water_messageState?.updateMessage(money: value);
            });
          });

        });
      }
      else
        ToastUtil.show('请先绑定机器');
    }
    else
      ToastUtil.show('请先绑定账号');
  }

  //用于热水打卡
  _hotOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.hotWater, WaterData.cardNum, WaterData.waterAccount).then((value){
          ToastUtil.show('${value['message']}');
        });
      }else
        ToastUtil.show('请先绑定机器');
    }
    else
      ToastUtil.show('请先绑定账号');
  }

  //用于热水关闭
  _hotCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.hotWater, WaterData.cardNum, WaterData.waterAccount).then((value){
          ToastUtil.show('${value['message']}');
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount, WaterData.waterSaler).then((value){
              //刷新信息
              home_water_messageState?.updateMessage(money: value);

            });
          });


        });

      }
      else
        ToastUtil.show('请先绑定机器');
    }
    else
      ToastUtil.show('请先绑定账号');
  }


  Widget _bingWater(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Container(
          height: 60,
          width: 100,
          child: ElevatedButton(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  Text('绑定')
                ],
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Colors.blue
                ),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                )
            ),
            onPressed: () async {

              String result = await Navigator.push(context, MaterialPageRoute(builder: (builder){
                return ScanQR_Water();
              }));
              //ToastUtil().show(result);
              WaterUtil().bindCoolWater(result);

            },
          ),),


        Container(
          height: 60,
          width: 100,
          child: ElevatedButton(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt),
                  Text('绑定')
                ],
              ),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Colors.pink
              ),
                shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                )
            ),
            onPressed: () async {
              String result = await Navigator.push(context, MaterialPageRoute(builder: (builder){
                return ScanQR_Water();
              }));
              //ToastUtil().show(result);
              WaterUtil().bindHotWater(result); //绑定热水

            },
          ),)


      ],
    );

  }

  String? _bingCard;
  Widget _bingAccount(){


    return Container(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('账号：${this._bingCard??"未绑定"}'),

          Row(
            children: [
              Visibility(
                visible: WaterData.waterAccount.isEmpty|| WaterData.waterAccount=="" ? false : true, //检查账号是否为空
                  child: Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: ElevatedButton(
                        onPressed: (){

                          Navigator.of(context).push(MaterialPageRoute(builder: (builder){
                            return WaterCharge();
                          }));

                        }
                        , child: Text('充值')),
                  )),
              ElevatedButton(
                  onPressed: (){
                    if( WaterData.waterAccount.isEmpty){
                      this._bingShow();
                    }else{
                      ShareDateUtil().setWaterUnBind().then((value){
                        setState((){
                          ToastUtil.show('解绑成功');
                        });
                      });
                    }

                  }
                  , child: Text('${WaterData.waterAccount.isEmpty ? "绑定" : "解绑"}'))
            ],
          )

        ],
      ),
    );

  }


  //绑定显示
   _bingShow(){

    String _url = "";

    showDialog(context: context, builder: (builder){

      return Dialog(
        child: Container(
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Text('请输入微信扫码后的链接',style: TextStyle(fontSize: 20),),
                  ),

                ],),
              Column(
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: '链接',
                          hintText: '请输入链接'
                      ),
                      onChanged: (v){
                        _url = v;
                      },
                    ),
                  ),
                ],
              ),
              Padding(padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: (){
                      ToastUtil.show('正在绑定,请稍后.....');
                      WaterUtil().bindAccount(_url).then(
                              (value){
                                if(value!="")
                                  setState((){
                                    _bingCard = WaterData.cardNum;
                                    ToastUtil.show('绑定成功');
                                    Navigator.pop(context);
                                    //更新数据
                                    WaterUtil().getMenoy(WaterData.waterAccount, WaterData.waterSaler).then((value){
                                      home_water_messageState?.updateMessage(money: value);
                                    });
                                  });
                                else
                                  ToastUtil.show('输入的链接有误');
                          });
                    },
                    child: Text('确定'),
                    color: Colors.blue,
                  ),),),
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: (){

                    },
                    child: Text('教程'),
                    color: Colors.blue,
                  ),),),

              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text('取消'),
                    color: Colors.white60,
                  ),),)


            ],
          ),
        ),
      );
    });


  }




  @override
  void initState() {

    if(WaterData.cardNum.isNotEmpty&& WaterData.cardNum!=null)
      this._bingCard = WaterData.cardNum;
  }

}



