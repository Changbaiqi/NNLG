/* FileName TrainPlanHttp
 *
 * @Author 20840
 * @Date 2024/2/2 1:59
 *
 * @Description TODO
 */

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/edusys/entity/TrainPlanInForm.dart';
import 'package:nnlg/utils/edusys/tools/TrainPlan.dart';

class TrainPlanWeb{


  BaseOptions _options = BaseOptions();

  TrainPlanWeb(){

    _options.baseUrl ='${ContextDate.ContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;
  }


  Future<List<TrainPlanInForm>> getTrainPlan() async {

    Response response = await Dio(_options).request(
        '/gllgdxbwglxy_jsxsd/pyfa/pyfa_query',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www.form-urlencoded',
          responseType: ResponseType.bytes,
          receiveTimeout: 4000,
        )
    );
    if(!await LoginUtil.checkLoginTimeOut(response)){
      return getTrainPlan();
    }
    List<TrainPlanInForm> list = TrainPlan(utf8.decode(response.data)).getTrainPlanList();
    return list;
  }


}