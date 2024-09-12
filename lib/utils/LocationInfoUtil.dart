/* FileName LocationInfoUtil
 *
 * @Author 20840
 * @Date 2024/9/12 17:21
 *
 * @Description TODO
 */

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class LocationInfoUtil{
// 用于获取个人定位信息
  static Future<dynamic> getLocationInfo() async {
    MethodChannel platform = const MethodChannel("LocationInfo");
    String returnValue = await platform.invokeMethod("");
    log(returnValue);
    return jsonDecode(returnValue);
  }
}
