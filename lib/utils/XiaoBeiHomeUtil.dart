
import 'dart:collection';

import 'package:dio/dio.dart';

import '../dao/ContextData.dart';

class XiaoBeiHomeUtil{




  BaseOptions _options = BaseOptions();

  XiaoBeiHomeUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }



  //获取自动打卡的开关状态
  Future<LinkedHashMap> getAutoPlaySW() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/autoPlaySW',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );
    //print('${response}');
    return response.data ;
  }
  //设置自动打开开关
  Future<LinkedHashMap> setAutoPlaySW(bool sw) async{
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/autoPlaySW/${sw?1:0}',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,
        )
    );
    //print('${response}');
    return response.data ;
  }

  //获取随机温度的开关
  Future<LinkedHashMap> getRandomTemperatureSW() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/randomTemperatureSW',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );
    //print('${response}');
    return response.data ;
  }
  //设置自动打开开关
  Future<LinkedHashMap> setRandomTemperatuerSW(bool sw) async{
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/randomTemperatureSW/${sw?1:0}',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,
        )
    );
    //print('${response}');
    return response.data ;
  }

  //获取每日打卡时间
  Future<LinkedHashMap> getEveryDayPlayCardTime() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/everyDayPlayCardTime',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );
    //print('${response}');
    return response.data ;
  }
  //设置每日打卡的时间
  Future<LinkedHashMap> setEveryDayPlayCardTime(String timeStr) async{
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/everyDayPlayCardTime',
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,
        ),
      data: {
          "playTime":'${timeStr}'
      }
    );
    //print('${response}');
    return response.data ;
  }

  //获取每日打卡地址
  Future<LinkedHashMap> getPlayCardLocation() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/playCardLocation',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );
    //print('${response}');
    return response.data ;
  }
  Future<LinkedHashMap> setPlayCardLocation(String location,String coordinates) async {
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/playCardLocation',
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,
        ),
      data: {
          "location":'${location}',
          "coordinates":'${coordinates}'
      }
    );
    //print('${response}');
    return response.data ;
  }

  //获取累计自动打卡天数
  Future<LinkedHashMap> getAutoPlaySumDays() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/autoPlaySumDays',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );
    //print('${response}');
    return response.data ;
  }


  //手动一键打卡
  Future<LinkedHashMap> setPlayOneCard() async {
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/onePlay',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,
        )
    );
    //print('${response}');
    return response.data ;
  }


}