

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/WaterData.dart';
import 'package:nnlg/utils/FileUtils.dart';
import 'package:nnlg/utils/LocationInfoUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/utils/WaterUtil.dart';
import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';

import 'state.dart';
import 'package:amap_flutter_location/amap_flutter_location.dart';
class MainWaterViewLogic extends GetxController {
  final MainWaterViewState state = MainWaterViewState();
  BuildContext? context=null;


  updateMessage({money,divice}){
    state.money.value=money??"";
    state.divice.value = divice??"";
  }


  Future<void> onRefresh() async {
    await WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
      //刷新信息
      updateMessage(money: value);
    });

  }





  //绑定显示
  bingShow(){

    String _url = "";

    showDialog(context: context!, builder: (builder){

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
                  width: MediaQuery.of(context!).size.width,
                  child: MaterialButton(
                    onPressed: (){
                      Get.snackbar("提示", "正在绑定,请稍后.....",duration: Duration(milliseconds: 1500),);
                      WaterUtil().bindAccount(_url).then(
                              (value){
                            if(value!="") {
                              state.bingCard.value = WaterData.cardNum.value;
                              Get.snackbar("提示", "绑定成功",
                                duration: Duration(milliseconds: 1500),);
                              Navigator.pop(context!);
                              //更新数据
                              WaterUtil()
                                  .getMenoy(
                                  WaterData.waterAccount.value, WaterData.waterSaler.value)
                                  .then((value) {
                                updateMessage(money: value);
                              });
                            }
                            else
                              Get.snackbar("提示", "输入的链接有误",duration: Duration(milliseconds: 1500),);
                          });
                    },
                    child: Text('确定'),
                    color: Colors.blue,
                  ),),),
              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context!).size.width,
                  child: MaterialButton(
                    onPressed: (){

                    },
                    child: Text('教程'),
                    color: Colors.blue,
                  ),),),

              Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Container(
                  width: MediaQuery.of(context!).size.width,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.pop(context!);
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


  //用于冷水关闭
  coolCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.coolWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
              //刷新信息
              updateMessage(money: value);
            });
          });

        });
      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }




  //用于热水打卡
  hotOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.hotWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
        });
      }else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }




  //用于热水关闭
  hotCloseWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.hotWater.isNotEmpty) {
        WaterUtil().closeWater(WaterData.hotWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          // Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          ToastUtil.show('${value['message']}');
          //用于刷新金额
          Timer(Duration(seconds: 1),(){
            WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
              //刷新信息
              updateMessage(money: value);
            });
          });


        });

      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }



  //用于冷水打卡
  coolOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.coolWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          // Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
          ToastUtil.show('${value['message']}');
        });

      }
      else
        Get.snackbar("提示", "请先绑定机器",duration: Duration(milliseconds: 1500),);
    }
    else
      Get.snackbar("提示", "请先绑定账号",duration: Duration(milliseconds: 1500),);
  }


  /// 位置服务
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    double longitude=0;
    double latitude=0;
    try {
      /// 手机GPS服务是否已启用。
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        //定位服务未启用，要求用户启用定位服务
        var res = await Geolocator.openLocationSettings();
        if (!res) {
          /// 被拒绝
          return;
        }
      }
      /// 是否允许app访问地理位置
      permission = await Geolocator.checkPermission();


      if (permission == LocationPermission.denied) {
        /// 之前访问设备位置的权限被拒绝，重新申请权限
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          /// 再次被拒绝。根据Android指南，你的应用现在应该显示一个解释性UI。
          return;
        }
      } else if (permission == LocationPermission.deniedForever) {
        /// 之前权限被永久拒绝，打开app权限设置页面
        await Geolocator.openAppSettings();
        return;
      }
      /// 允许访问地理位置，获取地理位置
      Position position = await Geolocator.getCurrentPosition();

      longitude = position.longitude;
      latitude = position.latitude;
    } catch (e) {
      print(e);
    }
  }

  //根据气压计算海拔高度
  calculateAltitude(double pressure){
    final double P0 = 1013.25; //海平面标准气压
    final double R = 287.05; //气体常数
    final double T0= 288.15; //海平面温度
    final double g = 9.80665; //重力加速度
    return (P0-pressure)*R*T0/(g*P0);
  }

  void test()async{


    Timer.periodic(Duration(seconds: 2), (timer) async{

      var locationInfo =await LocationInfoUtil.getLocationInfo();
      state.longitude.value = locationInfo['longitude'];
      state.latitude.value = locationInfo['latitude'];
      state.altitude.value = locationInfo['altitude'];
      state.sensor.value = locationInfo['sensor'];
      state.sensorAltitude1.value = calculateAltitude(state.sensor.value);
      state.sensorAltitude2.value = 44330000*(1.0-(pow(state.sensor.value/1013.25, 1.0/5255.0)));
    });
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 获取最强信号的前4个AP的MAC地址
   * [date] 20:33 2024/9/19
   * [param] null
   * [return]
   */
  getAPTopList() async{
      // setState(() => huntButtonColor = Colors.red);
    var wiFiHunterResult = WiFiHunterResult();
      try {
        wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
      } on PlatformException catch (exception) {
        ToastUtil.show('您点击定位过于频繁（限制两分钟4次定位频率）');
        print(exception.toString());
      }
      List result = [];
      for (int i = 0; i < wiFiHunterResult.results.length; i++) {
        if(wiFiHunterResult.results[i].frequency<5000) continue; //过滤频率低于5KHZ的
        if(wiFiHunterResult.results[i].ssid!="NNLGXY") continue; //过滤非NNLGXY名称的AP
          result.add({
            "SSID": wiFiHunterResult.results[i].ssid, //AP名称
            "Level": wiFiHunterResult.results[i].level, //信号强度
            "BSSID": wiFiHunterResult.results[i].bssid, //MAC地址
            "Capabilities": wiFiHunterResult.results[i].capabilities, //不懂啥玩意
            "Frequency": wiFiHunterResult.results[i].frequency.toString(), //频率
            "Channel Width": wiFiHunterResult.results[i].channelWidth.toString(), //信道
            "Timestamp": wiFiHunterResult.results[i].timestamp.toString() //时间
          });
      }
      result.sort((a,b)=>b["Level"].compareTo(a["Level"])); //根据信号强度排序
    return result;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 通过AP探测对应饮水机位置
   * [date] 20:46 2024/9/19
   * [param] null
   * [return]
   */
  Future<LinkedHashMap<dynamic,dynamic>?> detectWater()async{
    List resultAp = await getAPTopList(); //获取AP列表，以信号强度排序
    var localInformList = jsonDecode((await FileUtils.loadJsonFromAssets('assets/files/localWaterList.json')));
    // print(localInformList.toString());

    int maxComp =0; int index=-1; //最大匹配AP数量，匹配编号
    for(int i= 0 ;i<localInformList.length;++i){
      int localLen =localInformList[i]['ap'].length; //本地对照组数量
      int nowLen = resultAp.length; //当前实际对照组数量
      int resCompNum = 0; //临时计数

      for(int j =0; j<nowLen;++j){
       for(int z =0 ; z <localLen;++z){
         if(resultAp[j]['BSSID']==localInformList[i]['ap'][z]) ++resCompNum;
       }
      }
      if(maxComp<resCompNum){
        maxComp = resCompNum;
        index = i;
      }
    }
    if(index==-1) return null;

    return localInformList[index];
  }

  @override
  void onInit() {
    // ShareDateUtil().getTestList();
    // _determinePosition();
    // test();


    WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
        state.money.value = value;
    });
    if(WaterData.cardNum.isNotEmpty&& WaterData.cardNum!=null)
      state.bingCard.value = WaterData.cardNum.value;
  }
}
