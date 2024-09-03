import 'dart:collection';
import 'dart:developer';

import 'package:dio/dio.dart';
import '../dao/ContextData.dart';

class PowerDormUtil {
  BaseOptions _options = BaseOptions();

  PowerDormUtil() {
    _options.baseUrl = ContextDate.VIPContextUrl;
  }

  /**
   * 获取绑定的信息
   */
  Future<LinkedHashMap> getBindDorm() async {
    Response response = await Dio(_options).request('/user/getBindDorm',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            headers: {"Authorization": '${ContextDate.ContextVIPTken}'},
            receiveTimeout: const Duration(seconds: 15)));
    //print('数据${response.data}');
    return response.data;
  }

  /**
   * 用于设置修改预警绑定的邮箱
   */
  Future<LinkedHashMap> setBindDorm(
      String power_bind_dong,
      String power_bind_room,
      String power_bind_email,
      double power_min_money,
      int power_dorm_sw) async {
    Response response = await Dio(_options).request('/user/setBindDorm',
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
          headers: {"Authorization": '${ContextDate.ContextVIPTken}'},
          receiveTimeout: const Duration(seconds: 15),
        ));
    //print('${response}');
    return response.data;
  }

  /**
   * 软件通知
   */
  Future<LinkedHashMap> inform() async {
    Response response = await Dio(_options).request('/user/inform',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: const Duration(seconds: 15)));

    return response.data;
  }

  getDormPower(String campus, String loudong_id, String room) async {
    var roomUrl = "";
    var powerUrl = "";
    if (campus == "桂林") {
      if (loudong_id == "8" ||
          loudong_id == "8B" ||
          loudong_id == "8b" ||
          loudong_id == "8栋") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B8";
      }
      if (loudong_id == "10A" || loudong_id == "10a") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B101";
      }

      if (loudong_id == "10B" ||
          loudong_id == "10b" ||
          loudong_id == "10B栋" ||
          loudong_id == "10b栋") {
        roomUrl = "http://221.7.150.20:10004/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.20:10004/v1/cgElec/elec/query";
        loudong_id = "B102";
      }
      if (loudong_id == "9" || loudong_id == "9栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "B4320";
      }
      if (loudong_id == "7" || loudong_id == "7栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "4509";
      }
      if (loudong_id == "13" || loudong_id == "13栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "4812";
      }
      if (loudong_id == "14a" ||
          loudong_id == "14A" ||
          loudong_id == "14A栋" ||
          loudong_id == "14a栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "6436";
      }
      if (loudong_id == "14b" ||
          loudong_id == "14B" ||
          loudong_id == "14b栋" ||
          loudong_id == "14B栋") {
        roomUrl = "http://221.7.150.22:10005/v1/cgElec/room/query";
        powerUrl = "http://221.7.150.22:10005/v1/cgElec/elec/query";
        loudong_id = "6819";
      }
    } else if (campus == "南宁") {}
    Response response = await Dio(_options).request('${roomUrl}',
        options: Options(
          method: 'POST',
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: FormData.fromMap({"room_name": room, "loudong_id": loudong_id}));

    Response responsePower = await Dio(_options).request('${powerUrl}',
        options: Options(
          method: 'POST',
          receiveTimeout: const Duration(seconds: 15),
        ),
        data: FormData.fromMap({"room_id": response.data['data'][0]['room_id']}));
    // log(responsePower.data.toString());

    //print('数据${response.data}');
    return responsePower.data['data']['balance'].toString();
  }
}
