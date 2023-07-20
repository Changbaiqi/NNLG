import 'dart:collection';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class AppUpdateUtil {


  BaseOptions _options = BaseOptions();

  AppUpdateUtil() {
    _options.baseUrl = ContextDate.VIPContextUrl;
  }


  /**
   * 获取绑定的信息
   */
  Future<LinkedHashMap> getAppUpdate() async {
    Response response = await Dio(_options).request(
        '/user/getUpdate',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            headers: {
              "Authorization": '${ContextDate.ContextVIPTken}'
            },
            receiveTimeout: 15000
        )
    );
    //print('数据${response.data}');
    return response.data;
  }
}