import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../dao/WaterData.dart';
import 'ShareDateUtil.dart';
import 'ToastUtil.dart';


class WaterUtil{


  Future<String> bindAccount(String url) async {

    //http://wx.happy-ti.com/wxpay/scanqrcode/v0.html?openid=微信OPENID&deviceid=设备ID&app=WECHAT&token=&ch=
    RegExp regExp =new RegExp(r'http://wx\.happy-ti\.com/wxpay/scanqrcode/v0\.html\?openid=([^&]+)&deviceid=(\d+)&app=WECHAT&token=&ch=');
    bool check = regExp.hasMatch(url);
    if(check) {
      var result = regExp.firstMatch(url);
      String waterAccount = result?.group(1)??""; //openid
      String shop = result?.group(2)??"";
      String saler = "";
      String cardNum = "";
      String userId = ""; //或者说owner参数

      //通过机子号和微信openid获取saler
      Response getSaler = await Dio().request(
        'https://server.happy-ti.com/index.php?r=api/wxpay/v1/scanqrcode/initv0&deviceid=${shop}&openid=${waterAccount}&app=WECHAT',
        options: Options(
            method: 'GET'
        ),
      );


      Map<String,dynamic> getSaler_json = jsonDecode(getSaler.toString());
      saler = getSaler_json['data']['saler'];

      //通过担保人电话和微信openid获取用户全部信息
      Response userMessage = await Dio().request(
        'https://server.happy-ti.com/index.php?r=api/server/v1/cards/getcards&openid=${waterAccount}&saler=${saler}&app=WECHAT',
        options: Options(
            method: 'GET'
        ),
      );

      //debugPrint('${userMessage.data}');

      Map<String,dynamic> userMessage_json = jsonDecode(userMessage.toString());
      cardNum = userMessage_json['data'][0]['number'];
      userId = userMessage_json['data'][0]['owner'];

      await ShareDateUtil().setWaterSaler(saler);
      await ShareDateUtil().setWaterAccount(waterAccount);
      await ShareDateUtil().setCardNum(cardNum);
      await ShareDateUtil().setWaterUserId(userId);

      return WaterData.cardNum.value;
    }

    return "";

  }



  Future<void> bindHotWater(String url) async {

    //http://wx.happy-ti.com/wxpay/scanqrcode/v0.html?openid=微信OPENID&deviceid=设备ID&app=WECHAT&token=&ch=
    RegExp regExp =new RegExp(r'http://weixin\.happy-ti\.com/weixinpay/h5pay\.php\?device=(\d+)&user_id=qrcode');
    bool check = regExp.hasMatch(url);
    if(check) {
      var result = regExp.firstMatch(url);
      String shop = result?.group(1) ?? ""; //device 也就是机子ID
      ShareDateUtil().setHotWater(shop);
      ToastUtil.show('绑定成功');
    }else{
      ToastUtil.show('扫描的二维码有误');
    }

  }



  Future<void> bindCoolWater(String url) async {

    //http://wx.happy-ti.com/wxpay/scanqrcode/v0.html?openid=微信OPENID&deviceid=设备ID&app=WECHAT&token=&ch=
    RegExp regExp =new RegExp(r'http://weixin\.happy-ti\.com/weixinpay/h5pay\.php\?device=(\d+)&user_id=qrcode');
    //print(url);
    bool check = regExp.hasMatch(url);
    if(check) {
      var result = regExp.firstMatch(url);
      String shop = result?.group(1) ?? ""; //device 也就是机子ID
      ShareDateUtil().setCoolWater(shop);
      ToastUtil.show('绑定成功');
    }else{
      ToastUtil.show('扫描的二维码有误');
    }


  }



  Future<LinkedHashMap<String,dynamic>> openWater(String shop,String cardNum,String openId) async {



      //通过机子号和微信openid获取saler
      Response response = await Dio().request(
        'https://server.happy-ti.com/index.php?r=api/wxcardsale&shop=${shop}&cardnum=${cardNum}&openid=${openId}&ch=',
        options: Options(
            method: 'GET'
        ));

      //print(response.data);
       var json = jsonDecode(response.data);
       return json; //message是信息
  }

  Future<LinkedHashMap<String,dynamic>> closeWater(String shop,String cardNum,String openId) async {


    //通过机子号和微信openid获取saler
    Response response = await Dio().request(
        'https://server.happy-ti.com/index.php?r=api/wxcardsale&shop=${shop}&cardnum=${cardNum}&openid=${openId}&control=stop&ch=',
        options: Options(
            method: 'GET'
        )
    );

    var json = jsonDecode(response.data);
    return json; //message是信息

  }


  Future<String> getMenoy(String waterAccount,String saler) async {

    if(waterAccount.isNotEmpty&&saler.isNotEmpty) {
      //通过担保人电话和微信openid获取用户全部信息
      Response response = await Dio().request(
        'https://server.happy-ti.com/index.php?r=api/server/v1/cards/getcards&openid=${waterAccount}&saler=${saler}&app=WECHAT',
        options: Options(
            method: 'GET'
        ),
      );


      return response.data['data'][0]['totalvalue']; //message是信息
    }

    return "";

  }








}
