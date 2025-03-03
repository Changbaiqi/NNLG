import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import '../dao/ContextData.dart';
import '../dao/CustomThemeData.dart';
import 'CustomerThemeUtil.dart';

class PowerDormUtil {
  BaseOptions _options = BaseOptions();

  PowerDormUtil() {
    _options.baseUrl = ContextDate.VIPContextUrl;
  }

  /**
   * 获取绑定的信息
   */
  Future<LinkedHashMap> getBindDorm() async {
    Response response = await Dio(_options).request('/user/getBindDorm',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            headers: {"Authorization": '${ContextDate.ContextVIPTken}'},
            receiveTimeout: const Duration(seconds: 15)));
    //print('数据${response.data}');
    return response.data;
  }

  /**
   * 用于设置修改预警绑定的邮箱
   */
  Future<LinkedHashMap> setBindDorm(
      String power_bind_campus,
      String power_bind_dong,
      String power_bind_room,
      String power_bind_email,
      double power_min_money,
      int power_dorm_sw) async {
    Response response = await Dio(_options).request('/user/setBindDorm',
        data: {
          "power_bind_campus": "${power_bind_campus}",
          "power_bind_dong": "${power_bind_dong}",
          "power_bind_room": "${power_bind_room}",
          "power_bind_email": "${power_bind_email}",
          "power_min_money": power_min_money,
          "power_dorm_sw": power_dorm_sw
        },
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          headers: {"Authorization": '${ContextDate.ContextVIPTken}'},
          receiveTimeout: const Duration(seconds: 15),
        ));
    //print('${response}');
    return response.data;
  }

  /**
   * 软件通知
   */
  Future<LinkedHashMap> inform() async {
    Response response = await Dio(_options).request('/user/inform',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: const Duration(seconds: 15)));

    return response.data;
  }

  getDormPower(String campus, String loudong_id, String room) async {
    var roomUrl = "";
    var powerUrl = "";
    if (campus == "桂林") {
      if (loudong_id == "8" ||
          loudong_id == "8B" ||
          loudong_id == "8b" ||
          loudong_id == "8栋") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B8";
      }
      if (loudong_id == "10A" || loudong_id == "10a") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B101";
      }

      if (loudong_id == "10B" ||
          loudong_id == "10b" ||
          loudong_id == "10B栋" ||
          loudong_id == "10b栋") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B102";
      }
      if (loudong_id == "9" || loudong_id == "9栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "4320";
      }
      if (loudong_id == "7" || loudong_id == "7栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "4509";
      }
      if (loudong_id == "13" || loudong_id == "13栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "4812";
      }
      if (loudong_id == "14a" ||
          loudong_id == "14A" ||
          loudong_id == "14A栋" ||
          loudong_id == "14a栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "6436";
      }
      if (loudong_id == "14b" ||
          loudong_id == "14B" ||
          loudong_id == "14b栋" ||
          loudong_id == "14B栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "6819";
      }
    } else if (campus == "南宁") {
      if(loudong_id=="15-1栋"||loudong_id=="15-1"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="4320";
      }
      if(loudong_id=="15-2栋"||loudong_id=="15-2"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="4523";
      }
      if(loudong_id=="13-1栋"||loudong_id=="13-1"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="4722";
      }
      if(loudong_id=="13-2栋"||loudong_id=="13-2"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
    loudong_id="5158";
      }
      if(loudong_id=="17栋"||loudong_id=="17"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="5623";
      }
      if(loudong_id=="18栋"||loudong_id=="18"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="6068";
      }
      if(loudong_id=="19栋"||loudong_id=="19"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="6267";
      }
      if(loudong_id=="20栋"||loudong_id=="20"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="6454";
      }
      if(loudong_id=="21栋"||loudong_id=="21"){
        roomUrl = "http://202.103.236.36:10002/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10002/v1/cgElec/elec/query";
        loudong_id="6899";
      }
      for(int i =1;i<=12;++i){
        if(loudong_id=="${i}号楼" || loudong_id=="B${i}"){
          roomUrl = "http://202.103.236.36:10001/v1/cgElec/room/query";
          powerUrl = "http://202.103.236.36:10001/v1/cgElec/elec/query";
          loudong_id="B${i}";
          break;
        }
      }
      if(loudong_id=="14号楼"||loudong_id=="B19"){
        roomUrl = "http://202.103.236.36:10001/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10001/v1/cgElec/elec/query";
        loudong_id="B19";
      }
      if(loudong_id=="16号楼"||loudong_id=="B16"){
        roomUrl = "http://202.103.236.36:10001/v1/cgElec/room/query";
        powerUrl = "http://202.103.236.36:10001/v1/cgElec/elec/query";
        loudong_id="B16";
      }
      for(int i =1;i<=2;++i){
        if(loudong_id=="致远楼${i}单元" || loudong_id=="B${i+19}"){
          roomUrl = "http://202.103.236.36:10001/v1/cgElec/room/query";
          powerUrl = "http://202.103.236.36:10001/v1/cgElec/elec/query";
          loudong_id="B${i+19}";
          break;
        }
      }
      for(int i =1;i<=2;++i){
        if(loudong_id=="德馨楼${i}单元" || loudong_id=="B${i+21}"){
          roomUrl = "http://202.103.236.36:10001/v1/cgElec/room/query";
          powerUrl = "http://202.103.236.36:10001/v1/cgElec/elec/query";
          loudong_id="B${i+21}";
          break;
        }
      }
    }
    Response response = await Dio(_options).request('${roomUrl}',
        options: Options(
          method: 'POST',
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: FormData.fromMap({"room_name": room, "loudong_id": loudong_id}));

    Response responsePower = await Dio(_options).request('${powerUrl}',
        options: Options(
          method: 'POST',
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: FormData.fromMap({"room_id": response.data['data'][0]['room_id']}));
    // log(responsePower.data.toString());

    //print('数据${response.data}');
    return responsePower.data['data']['balance'].toString();
  }





  static dormList(){
    var multiData = {
      '桂林': {
        '7栋': [],
        '8栋': [],
        '9栋': [],
        '10A栋': [],
        '10B栋': [],
        '12栋': [],
        '13栋': [],
        '14A栋': [],
        '14B栋': [],
      },
      '南宁': {
        '13-1栋': [],
        '13-2栋': [],
        '15-1栋': [],
        '15-2栋': [],
        '17栋': [],
        '18栋': [],
        '19栋': [],
        '20栋': [],
        '21栋': [],
        '1号楼': [],
        '2号楼': [],
        '3号楼': [],
        '4号楼': [],
        '5号楼': [],
        '6号楼': [],
        '7号楼': [],
        '8号楼': [],
        '9号楼': [],
        '10号楼': [],
        '11号楼': [],
        '12号楼':[],
        '14号楼': [],
        '16号楼': [],
        // '致远楼一单元': [],
        // '致远楼二单元': [],
        // '德馨楼一单元': [],
        // '德馨楼二单元': [],
        // '博雅楼一单元': [],
        // '博雅楼二单元': [],
      }
    };
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 35; ++y) {
        multiData['桂林']?['7栋']?.add('${x * 100 + y}');
        multiData['桂林']?['8栋']?.add('${x * 100 + y}');
        multiData['桂林']?['9栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10A栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10B栋']?.add('${x * 100 + y}');
        multiData['桂林']?['12栋']?.add('${x * 100 + y}');
      }
    }
    //桂林13栋
    for (int j = 1; j <= 9; ++j)
      for (int i = 1; i <= 8; ++i)
        multiData['桂林']?['13栋']?.add('${j * 100 + i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1101; i <= 1108; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    //桂林14A栋
    for (int j = 1; j <= 6; ++j)
      for (int i = 1; i <= 64; ++i)
        multiData['桂林']?['14A栋']?.add('${j * 1000 + i}');
    //桂林14B栋
    for (int i = 1066; i <= 1141; ++i) multiData['桂林']?['14B栋']?.add('${i}');
    for (int j = 2; j <= 6; ++j)
      for (int i = 64; i <= 139; ++i)
        multiData['桂林']?['14B栋']?.add('${j * 1000 + i}');

    //南宁校区----



    //13-2栋
    for (int j = 1; j <= 9; ++j){
      for (int i = 40; i <= 88; ++i) {
        multiData['南宁']?['13-2栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 38; i <= 288; ++i) {
      multiData['南宁']?['13-2栋']?.add('${1000 + i}');
    }
    //15-1
    for (int j = 1; j <= 6; ++j) {
      for (int i = 1; i <= 47; ++i) {
        multiData['南宁']?['15-1栋']?.add('${j * 100 + i}');
      }
    }
    //15-2栋
    for (int i = 33; i <= 68; ++i){ multiData['南宁']?['15-2栋']?.add('${100 + i}');}
    for (int j = 2; j <= 6; ++j){
      for (int i = 49; i <= 84; ++i) {
        multiData['南宁']?['15-2栋']?.add('${j * 100 + i}');
      }
    }

    //13-1、17、20、21栋
    for (int j = 1; j <= 9; ++j) {
      for (int i = 1; i <= 36; ++i) {
        multiData['南宁']?['13-1栋']?.add('${j * 100 + i}');
        multiData['南宁']?['17栋']?.add('${j * 100 + i}');
        multiData['南宁']?['20栋']?.add('${j * 100 + i}');
        multiData['南宁']?['21栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 1; i <= 236; ++i) {
      multiData['南宁']?['13-1栋']?.add('${1000 + i}');
      multiData['南宁']?['17栋']?.add('${1000 + i}');
      multiData['南宁']?['20栋']?.add('${1000 + i}');
      multiData['南宁']?['21栋']?.add('${1000 + i}');
    }
    //18、19栋
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 47; ++y) {
        multiData['南宁']?['18栋']?.add('${x * 100 + y}');
        multiData['南宁']?['19栋']?.add('${x * 100 + y}');
      }
    }

    //1，3号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['1号楼']?.add('${x*100 + y}');
        multiData['南宁']?['3号楼']?.add('${x*100 + y}');
      }
    }
    //2号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['2号楼']?.add('${x*100 + y}');
      }
    }
    for (int y = 1; y <= 48; ++y) {
      multiData['南宁']?['2号楼']?.add('${1100 + y}');
    }

    //4、5、9号楼
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 24; ++y) {
        multiData['南宁']?['4号楼']?.add('${x * 100 + y}');
        multiData['南宁']?['5号楼']?.add('${x * 100 + y}');
      }
    }
    //6号楼
    for (int x = 1; x <= 8; ++x) {
      for (int y = 1; y <= 36; ++y) {
        multiData['南宁']?['6号楼']?.add('${x * 100 + y}');
      }
    }

    //7号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 60; ++y) {
        multiData['南宁']?['7号楼']?.add('${x * 100 + y}');
      }
    }

    //8号楼
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['6号楼']?.add('${x * 100 + y}');
      }
    }
    //10、11、12、16
    for(int x=101;x<=676;++x){
      multiData['南宁']?['8号楼']?.add('${x}');
      multiData['南宁']?['9号楼']?.add('${x}');
      multiData['南宁']?['10号楼']?.add('${x}');
      multiData['南宁']?['11号楼']?.add('${x}');
      multiData['南宁']?['12号楼']?.add('${x}');
      multiData['南宁']?['16号楼']?.add('${x}');
    }
    //14栋
    multiData['南宁']?['14号楼']?.add('10A');
    multiData['南宁']?['14号楼']?.add('10B');
    for(int x=1;x<=9;++x){
      for(int y=1;y<=88;++y) {
        multiData['南宁']?['14号楼']?.add('${x*100+y}');
      }
    }
    for(int x=1000;x<=1288;++x){
      multiData['南宁']?['14号楼']?.add('${x}');
    }
    return multiData;
  }
}
