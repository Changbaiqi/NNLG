
import 'dart:collection';
import 'dart:convert';

import 'package:dio/dio.dart';
// import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:fluwx/fluwx.dart';
import 'package:nnlg/utils/ToastUtil.dart';

/**
 * 一信通
 */
class JustMessengerUtil{



  BaseOptions _options = BaseOptions();


  JustMessengerUtil(){
    // _options.baseUrl ='${ContextDate.ContextUrl}';
  }

  //注册微信
  void wxPay() async{
    Fluwx fluwx = Fluwx();

    await fluwx.registerApi(
      appId: "wxdabec6d322fbb293",
      universalLink: "https://help.wechat.com/app",
    );

    //是否安装微信
    bool isInstalled = await fluwx.isWeChatInstalled;
    if (!isInstalled) {
      // Get.snackbar("支付提示","请先安装微信");
      // Toast.showMsg("请先安装微信");
      return;
    }
    await getWXPlayApi(0.01).then((value){
      print(value);
      // print(value['data']['sign']);
      // value['data']
      var wxPayJson = jsonDecode(value['data']['data']);
      String package = wxPayJson['package'];
      String appid = wxPayJson['appid'];
      String sign = wxPayJson['sign'];
      String partnerid = wxPayJson['partnerid'];
      String prepayid = wxPayJson['prepayid'];
      String noncestr = wxPayJson['noncestr'];
      String timestamp = wxPayJson['timestamp'];
      fluwx.pay(which: Payment(appId: appid, partnerId: partnerid, prepayId: prepayid, packageValue: package, nonceStr: noncestr, timestamp: int.parse(timestamp), sign: sign)).then((event){
        if(event){}
      });
      //监听微信回调
      fluwx.addSubscriber((response) => {
        if(response.isSuccessful){
          ToastUtil.show('微信支付成功')
        }else{
          ToastUtil.show(response.errStr??"微信支付成功")
        }
      });
    });

    //fluwx.pay(which: Payment(appId: appId, partnerId: partnerId, prepayId: prepayId, packageValue: packageValue, nonceStr: nonceStr, timestamp: timestamp, sign: sign))
    //调起支付
    // fluwx.payWithWeChat(
    //   appId: "开放平台appId",
    //   partnerId: "partnerId",
    //   prepayId: "prepayId",
    //   packageValue: "packageValue",
    //   nonceStr: "nonceStr",
    //   timeStamp: 1597927308,
    //   sign: "sign",
    // );
    //监听微信回调
    // fluwx.weChatResponseEventHandler.listen((event) {
    //   if(event.isSuccessful) {
    //     Toast.showMsg("微信支付成功");
    //   } else {
    //     Toast.showMsg(event.errStr??"微信支付成功");
    //   }
    // });
  }



    /**
   * 一信通登录
   */
  Future<LinkedHashMap<String,dynamic>> loginPost(String username,String password) async {
      Response response = await Dio(_options).request(
          'http://platform.qzdatasoft.com/88/authentication/form',
          options: Options(
            method: 'POST',
            contentType: 'multipart/form-data; boundary=----WebKitFormBoundaryZbrCdfxSNKXrm4u9',
            responseType: ResponseType.plain,
            // receiveTimeout: 4000,
            headers: {
              'Authorization': 'Basic bGV2aWFfY2xpZW50OmxldmlhX3NlY3JldA==',
              'Host': 'platform.qzdatasoft.com',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            }
          ),
          queryParameters: {
            'grant_type': 'password',
            'password': password,
            'scope': 'all',
            'username': username
          }
      );
      return jsonDecode(response.data);
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取卡内金额
   * [date] 1:02 2024/2/26
   * [param] null
   * [return]
   */
  Future<LinkedHashMap<String,dynamic>> getMoney() async{
    Response response = await Dio(_options).request(
        'http://card.beitoucloud.com/bwgl_remoteservice/cardController/getAccountBln',
        options: Options(
            method: 'GET',
            // contentType: 'multipart/form-data; boundary=----WebKitFormBoundaryZbrCdfxSNKXrm4u9',
            // responseType: ResponseType.plain,
            // receiveTimeout: 4000,
            headers: {
              'Authorization': 'bearer ${AccountData.justMessengerAccess_Token.value}',
              'Host': 'card.beitoucloud.com',
              'Accept': '*/*',
              'Connection': 'keep-alive'
            }
        )
    );

    return response.data;
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取一信通卡的信息
   * [date] 1:25 2024/2/26
   * [param] null
   * [return]
   */
  Future<LinkedHashMap<String,dynamic>> getJustMessengerCardMessage() async{
    Response response = await Dio(_options).request(
        'http://card.beitoucloud.com/bwgl_remoteservice/user/findCardByStuCode',
        options: Options(
            method: 'POST',
            // contentType: 'multipart/form-data; boundary=----WebKitFormBoundaryZbrCdfxSNKXrm4u9',
            // responseType: ResponseType.plain,
            // receiveTimeout: 4000,
            headers: {
              'Authorization': 'bearer ${AccountData.justMessengerAccess_Token}',
              // 'Host': 'platform.qzdatasoft.com',
              // 'Accept': '*/*',
              // 'Connection': 'keep-alive'
            }
        ),
    );
    return response.data;
  }


  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 获取微信支付接口
   * [date] 2:04 2024/2/26
   * [param] null
   * [return]
   */
  Future<LinkedHashMap<String,dynamic>> getWXPlayApi(double money)async{
    Response response = await Dio(_options).request(
      'http://card.beitoucloud.com/bwgl_remoteservice/pay/wxAppPay',
      options: Options(
          method: 'POST',
          headers: {
            'Authorization': 'bearer ${AccountData.justMessengerAccess_Token}',
          }
      ),
        queryParameters: {
          'amount': money
        }
    );
    return response.data;
  }


}