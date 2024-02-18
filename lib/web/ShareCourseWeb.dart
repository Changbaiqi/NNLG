/* FileName ShareCourseWeb
 *
 * @Author 20840
 * @Date 2024/2/11 0:20
 *
 * @Description TODO
 *               */
import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/entity/model/ShareCourseAccountModel.dart' as ShareCourseAccountModel;
import 'package:nnlg/entity/model/ShareCourseDataModel.dart' as ShareCourseDataModel;

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
  Future<ShareCourseAccountModel.ShareCourseAccountModel> getShareAccountList() async {
    Response response = await Dio(_options).request(
        '/user/course/getShareAccountList',
        options: Options(
          method: 'GET',
          contentType: 'application/json',
          receiveTimeout: 4000,
          headers: {
            'Authorization': ContextDate.ContextVIPTken
          }
        )
    );
    ShareCourseAccountModel.ShareCourseAccountModel model = ShareCourseAccountModel.ShareCourseAccountModel.fromJson(response.data);
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
  Future<Map<dynamic,dynamic>> getShareCourseData(String studentId,String semester) async {
    print(studentId);
    Response response = await Dio(_options).request(
        '/user/course/getShareCourseData/${studentId}/${semester}',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: 15000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        )
    );
    return response.data;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 共享账号搜索接口
   * [date] 20:28 2024/2/12
   * [param] null
   * [return]
   */
  Future<Map<dynamic,dynamic>> searchShareCourseData(String searchKey) async {

    Response response = await Dio(_options).request(
        '/user/course/searchAccount',
        options: Options(
            method: 'POST',
            contentType: 'application/json',
            receiveTimeout: 15000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        ),
      data: {
          "searchKey": '${searchKey}'
      }
    );
    return response.data;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取自己共享给别人的账号列表
   * [date] 5:25 2024/2/11
   * [param] null
   * [return]
   */
  Future<Map<dynamic,dynamic>> getShareMeShareList() async {
    Response response = await Dio(_options).request(
        '/user/course/getShareMeShareList',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: 15000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        )
    );
    return response.data;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 添加共享给别人的账号
   * [date] 5:25 2024/2/11
   * [param] null
   * [return]
   */
  Future<Map<dynamic,dynamic>> addShareMeShare(String studentId) async {
    Response response = await Dio(_options).request(
        '/user/course/addShareCourseAccount/${studentId}',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: 15000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        )
    );
    return response.data;
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 删除共享给别人的账号
   * [date] 5:25 2024/2/11
   * [param] null
   * [return]
   */
  Future<Map<dynamic,dynamic>> deleteShareMeShare(String studentId) async {
    Response response = await Dio(_options).request(
        '/user/course/deleteShareCourseAccount/${studentId}',
        options: Options(
            method: 'GET',
            contentType: 'application/json',
            receiveTimeout: 15000,
            headers: {
              'Authorization': ContextDate.ContextVIPTken
            }
        )
    );
    return response.data;
  }


}