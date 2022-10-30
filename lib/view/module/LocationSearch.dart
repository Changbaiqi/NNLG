import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class LocationSearch{

  Future<LinkedHashMap> searchLocation(String localName) async{

    Response response = await Dio().request(
      'https://restapi.amap.com/v3/place/text?keywords=${localName}&offset=20&page=1&extensions=base&key=a75156548f968549660115cb544d0e1b',
      options: Options(
          method: 'GET'
      ),
    );
   // print(response.data);
    //LinkedHashMap<String,dynamic> hh = response.data;
    //防止非法返回值
    if(response!=null || response!="") {
      //print('联网获取的Session：${response.headers.value('Set-Cookie')}');
      //ShareDateUtil().setCookie(response.headers.value('Cookie').toString());
      return response.data;
    } else
      return LinkedHashMap();

  }


  Future<LinkedHashMap> getLocationText(double x ,double y) async{

    Response response = await Dio().request(
      'https://restapi.amap.com/v3/geocode/regeo?key=a75156548f968549660115cb544d0e1b&location=${x},${y}&poitype=&radius=100&extensions=base&batch=false&roadlevel=1',
      options: Options(
          method: 'GET'
      ),
    );
     //ToastUtil().show('${response.data}');
    //LinkedHashMap<String,dynamic> hh = response.data;
    //防止非法返回值
    if(response!=null || response!="") {
      return response.data;
    } else
      return LinkedHashMap();

  }


  static String toLocalText(value){

    LinkedHashMap<String,dynamic> ceshi = value['regeocode']['addressComponent'];
    //ToastUtil().show('${ceshi}');
    String str = "";
    if(ceshi['country'].toString()!="[]"&&ceshi['country'].toString()!=""&&ceshi['country'].toString()!=null)
      str+='${ceshi['country']}';
    if(ceshi['province'].toString()!="[]"&&ceshi['province'].toString()!=""&&ceshi['province'].toString()!=null)
      str+='-${ceshi['province']}';
    if(ceshi['city'].toString()!="[]"&&ceshi['city'].toString()!=""&&ceshi['city'].toString()!=null)
      str+='-${ceshi['city']}';
    if(ceshi['district'].toString()!="[]"&&ceshi['district'].toString()!=""&&ceshi['district'].toString()!=null)
      str+='-${ceshi['district']}';
    if(ceshi['township'].toString()!="[]"&&ceshi['township'].toString()!=""&&ceshi['township'].toString()!=null)
      str+='-${ceshi['township']}';
    return str;
  }





}