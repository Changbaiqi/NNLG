import 'dart:collection';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class SoftwareUpdateUtil{



  BaseOptions _options = BaseOptions();

  MainUserUtil(){
    _options.baseUrl = ContextDate.VIPContextUrl;
  }


  /**
   * 检测软件更新
   */
  Future<LinkedHashMap> checkUpdate() async {
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