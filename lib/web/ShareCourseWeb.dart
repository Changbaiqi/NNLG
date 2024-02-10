/* FileName ShareCourseWeb
 *
 * @Author 20840
 * @Date 2024/2/11 0:20
 *
 * @Description TODO
 *               */
import 'package:dio/dio.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart';
import 'package:nnlg/entity/model/ShareCourseDataModel.dart';

class ShareCourseWeb{

  BaseOptions _options = BaseOptions();

  ShareCourseWeb(){

    _options.baseUrl ='${ContextDate.VIPContextUrl}';
    _options.headers['Cookie'] = ContextDate.ContextCookie;
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取共享课表的账号名单
   * [date] 5:24 2024/2/11
   * [param] null
   * [return]
   */
  Future<ShareCourseAccountModel> getShareAccountList() async {
    Response response = await Dio(_options).request(
        '/user/course/getShareAccountList',
        options: Options(
          method: 'GET',
          contentType: 'application/x-www.form-urlencoded',
          receiveTimeout: 4000,
          headers: {
            'Authorization': ContextDate.ContextVIPTken
          }
        )
    );
    ShareCourseAccountModel model = ShareCourseAccountModel.fromJson(response.data);
    return model;
  }

  /**
   * [title] 
   * [author] 长白崎
   * [description] TODO 获取共享课表数据内容
   * [date] 5:25 2024/2/11
   * [param] null
   * [return] 
   */
  Future<ShareCourseDataModel> getShareCourseData(String studentId) async {
    Response response = await Dio(_options).request(
        '/user/course/getShareCourseData/${studentId}',
        options: Options(
            method: 'GET',
            contentType: 'application/x-www.form-urlencoded',
            receiveTimeout: 4000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        )
    );
    ShareCourseDataModel model = ShareCourseDataModel(code: response.data['code'],data: response.data['data'],message: response.data['message']);
    return model;
  }


}