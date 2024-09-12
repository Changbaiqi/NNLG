

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/WaterData.dart';
import 'package:nnlg/utils/WaterUtil.dart';

import 'state.dart';

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



  //用于冷水打卡
  coolOpenWaterButtonCheck(){
    if(WaterData.waterAccount.isNotEmpty&& WaterData.cardNum.isNotEmpty) {
      if(WaterData.coolWater.isNotEmpty) {
        WaterUtil().openWater(WaterData.coolWater.value, WaterData.cardNum.value, WaterData.waterAccount.value).then((value){
          Get.snackbar("提示", "${value['message']}",duration: Duration(milliseconds: 1500),);
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

  void test()async{

    Timer.periodic(Duration(seconds: 2), (timer) async{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      print(position);
      print(position.altitude);
      print(position.altitudeAccuracy);
      // print(position.)
    });
  }
  @override
  void onInit() {
    // _determinePosition();
    // test();
    WaterUtil().getMenoy(WaterData.waterAccount.value, WaterData.waterSaler.value).then((value){
        state.money.value = value;
    });
    if(WaterData.cardNum.isNotEmpty&& WaterData.cardNum!=null)
      state.bingCard.value = WaterData.cardNum.value;
  }
}
