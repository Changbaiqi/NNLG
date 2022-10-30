


import 'dart:collection';

import 'package:dio/dio.dart';

import '../dao/ContextData.dart';

class XiaoBeiLoginUtil{


  BaseOptions _options = BaseOptions();

  XiaoBeiLoginUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }



//设置自动打卡的账号和密码
  Future<LinkedHashMap> setBindXiaoBeiAccountAndPassword(String xiaoBeiAccount,String xiaoBeiPassword) async {
    Response response = await Dio(_options).request(
        '/playCard/setPlayCard/bindXiaoBeiAccountAndPassword',
        data: {
          "xiaoBeiAccount":'${xiaoBeiAccount}',
          "xiaoBeiPassword":'${xiaoBeiPassword}',
        },
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          headers: {
            "Authorization":'${ContextDate.ContextVIPTken}'
          },
          receiveTimeout: 4000,

        )
    );
    //print('${response}');
    return response.data ;
  }







}