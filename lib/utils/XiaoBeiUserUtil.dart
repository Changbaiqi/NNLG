

import 'dart:collection';

import 'package:dio/dio.dart';

import '../dao/ContextData.dart';

class XiaoBeiUserUtil{
  BaseOptions _options = BaseOptions();

  XiaoBeiUserUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }



  //获取自动打卡的开关状态
  Future<LinkedHashMap> getBindXiaoBeiAccountAndPassword() async {
    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/bindXiaoBeiAccountAndPassword',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 10000,

        )
    );
    //print('${response}');
    return response.data ;
  }

  Future<LinkedHashMap> getOpenStartAndEndTime() async {


    Response response = await Dio(_options).request(
        '/playCard/getPlayCard/openStartAndEndTime',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 10000,

        )
    );

    return response.data;
  }


  //获取小北自动打卡的公告
  Future<LinkedHashMap> getXiaoBeiNotice() async {


    Response response = await Dio(_options).request(
        '/playCard/playCard/getNotice',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 15000,

        )
    );

    return response.data;
  }


}