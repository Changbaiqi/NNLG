import 'dart:collection';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class MainUserUtil{



  BaseOptions _options = BaseOptions();

  MainUserUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }





  Future<LinkedHashMap> vipLogin(String account, String passowrd) async {



    Response response = await Dio(_options).request(
        '/user/toLogin',
        data: {
          "account": '${account}',
          "password":'${passowrd}'
        },
        options: Options(
          method: 'POST',
          contentType: 'application/json',
          receiveTimeout: 4000,

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
        receiveTimeout: 4000
      )
    );

    return response.data;
  }







}