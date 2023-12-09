
import 'dart:collection';

import 'package:dio/dio.dart';

/**
 * 一信通
 */
class JustMessengerUtil{



  BaseOptions _options = BaseOptions();


  JustMessengerUtil(){
    // _options.baseUrl ='${ContextDate.ContextUrl}';
  }


  /**
   * 一信通登录
   */
  Future<LinkedHashMap<String,dynamic>> LoginPost(String password,String username) async {
      Response response = await Dio(_options).request(
          'http://platform.qzdatasoft.com/88/authentication/form',
          options: Options(
            method: 'POST',
            contentType: 'multipart/form-data; boundary=----WebKitFormBoundaryZbrCdfxSNKXrm4u9',
            receiveTimeout: 4000,
            headers: {
              'Authorization': 'Basic bGV2aWFfY2xpZW50OmxldmlhX3NlY3JldA==',
              'Host': 'platform.qzdatasoft.com',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            }
          ),
          data: {
            'grant_type': 'password',
            'password': password,
            'scope': 'all',
            'username': username
          }
      );
      return response.data;
  }


}