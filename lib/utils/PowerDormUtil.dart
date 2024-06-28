import 'dart:collection';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class PowerDormUtil{



  BaseOptions _options = BaseOptions();

  PowerDormUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }


  /**
   * 获取绑定的信息
   */
  Future<LinkedHashMap> getBindDorm() async{
    Response response = await Dio(_options).request(
      '/user/getBindDorm',
      options: Options(
        method: 'GET',
        contentType: 'application/json',
        headers: {
          "Authorization": '${ContextDate.ContextVIPTken}'
        },
        receiveTimeout: const Duration(seconds: 15)
      )
    );
    //print('数据${response.data}');
    return response.data;
  }

  /**
   * 用于设置修改预警绑定的邮箱
   */
  Future<LinkedHashMap> setBindDorm(String power_bind_dong,String power_bind_room,
      String power_bind_email,double power_min_money,int power_dorm_sw) async {
    Response response = await Dio(_options).request(
        '/user/setBindDorm',
        data: {
          "power_bind_dong": "${power_bind_dong}",
          "power_bind_room": "${power_bind_room}",
          "power_bind_email": "${power_bind_email}",
          "power_min_money": power_min_money,
          "power_dorm_sw": power_dorm_sw
        },
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          headers: {
            "Authorization": '${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: const Duration(seconds: 15),
        )
    );
    //print('${response}');
    return response.data ;
  }


  /**
   * 软件通知
   */
  Future<LinkedHashMap> inform() async {
    Response response = await Dio(_options).request(
        '/user/inform',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: const Duration(seconds: 15)
        )
    );

    return response.data;
  }







}