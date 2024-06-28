import 'dart:collection';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class NoticeUtil {


  BaseOptions _options = BaseOptions();

  NoticeUtil() {
    _options.baseUrl = ContextDate.VIPContextUrl;
  }


  /**
   * 获取绑定的信息
   */
  Future<LinkedHashMap> getNotice() async {
    Response response = await Dio(_options).request(
        '/user/getNotice',
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
}