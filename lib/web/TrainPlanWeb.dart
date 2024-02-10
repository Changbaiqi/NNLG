/* FileName TrainPlanHttp
 *
 * @Author 20840
 * @Date 2024/2/2 1:59
 *
 * @Description TODO
 */

import 'package:dio/dio.dart';
import 'package:nnlg/dao/ContextData.dart';
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
          receiveTimeout: 4000,
        )
    );
    List<TrainPlanInForm> list = TrainPlan(response.data).getTrainPlanList();
    return list;
  }


}