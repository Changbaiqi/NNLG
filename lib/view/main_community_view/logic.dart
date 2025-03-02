import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/AccountUtil.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/JustMessengerUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/edusys/Account.dart';
import 'package:callo/view/SchoolCardInformSet.dart';
import 'package:callo/view/module/DashedLind.dart';
import 'package:callo/view/router/Routes.dart';

import '../../utils/PowerDormUtil.dart';
import 'state.dart';

class MainCommunityViewLogic extends GetxController {
  final MainCommunityViewState state = MainCommunityViewState();
  BuildContext? context = null;

  final TextEditingController inputAccountController = TextEditingController();
  final TextEditingController inputPasswordController = TextEditingController();
  final seeNo_Off = false.obs;

  /**
   * Lottie网格布局子组件
   */
  Widget boxChildLottie(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LottieBuilder.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),
          )
        ],
      ),
    );
  }

  /**
   * svg网格布局子组件
   */
  Widget boxChildSvg(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),
          )
        ],
      ),
    );
  }

  /**
   * img网格布局子组件
   */
  Widget boxChildImg(String imgFile, String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            imgFile,
            height: 25,
            width: 25,
          ),
          Text(
            label,
            style: TextStyle(fontSize: 11),
          )
        ],
      ),
    );
  }

  /**
   * 用于初始化显示软件打开次数
   */
  getOnClickTotal() {
    AccountUtil().getOnclickTotal().then((value) {
      if (value['code'] == 200) {
        state.onClickTotal.value = value['msg'];
      }
    });
  }




  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 登录一信通函数
   * [date] 1:08 2024/2/26
   * [param] null
   * [return]
   */
  loginJustMessage(String account, String password, bool isShowSnackbar) {
    JustMessengerUtil().loginPost(account, password).then((value) async {
      // print(value);
      if (value['resultCode'] != null) {
        if (value['message'] == 'Bad credentials') {
          Get.snackbar('提示', '密码错误',
              duration: const Duration(milliseconds: 1500));
          return;
        }
        Get.snackbar('提示', value['message'],
            duration: const Duration(milliseconds: 1500));
        return;
      }

      ShareDateUtil().setJustMessengerAccount(account); //寄存账号
      // AccountData.justMessengerAccount.value = account; //寄存账号
      // AccountData.justMessengerPassword.value = password; //寄存密码
      ShareDateUtil().setJustMessengerPassword(password); //寄存密码

      //装置token等参数
      AccountData.justMessengerAccess_Token.value = value['access_token'];
      AccountData.justMessengerRefresh_Toekn.value = value['refresh_token'];
      AccountData.justMessengerSchoolId.value = value['schoolId']; //设置学校id
      AccountData.justMessengerCompany.value = value['company']; //设置公司棉城
      AccountData.justMessengerExpires_in.value = value['expires_in'];
      AccountData.justMessengerToken_Type.value = value['token_type'];
      AccountData.justMessengerJti.value = value['jti'];

      //获取卡的信息
      await JustMessengerUtil().getJustMessengerCardMessage().then((value) {
        //如果获取卡信息异常
        if (value['code'] != 200) {
          Get.snackbar('获取一信通信息提示', '${value['message']}',
              duration: const Duration(milliseconds: 1500));
          return;
        }

        AccountData.justMessengerMoney.value =
            value['data'][0]['accountBlance'].toString(); //赋值金额
        AccountData.justMessengerCardCode.value = value['data'][0]['crdId'];
      });
      // JustMessengerUtil().getMoney().then((value){
      //   // Get.snackbar("金额", '${value['data']}');
      //   state.justMessengerMoney.value = value['data'];
      // });
      if (isShowSnackbar)
        Get.snackbar('提示', '登录成功',
            duration: const Duration(milliseconds: 1500));
      AccountData.isLoginJustMessenger.value = true; //设置为成功登录状态
    });
  }

  /**
   * 绑定过后的一信通信息卡片
   */
  bindingJustMessengerCard() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text('卡号：${AccountData.justMessengerCardCode.value}')),
              Obx(() => Text('${AccountData.justMessengerUserName.value}')),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Obx(() => Text(
                '￥ ${AccountData.justMessengerMoney.value}',
                style: TextStyle(fontSize: 35),
              )),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context!).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    //获取卡的信息
                    await JustMessengerUtil()
                        .getJustMessengerCardMessage()
                        .then((value) {
                      //如果获取卡信息异常
                      if (value['code'] != 200) {
                        Get.snackbar('获取一信通信息提示', '${value['message']}',
                            duration: const Duration(milliseconds: 1500));
                        return;
                      }

                      state.justMessengerMoney.value =
                          value['data'][0]['accountBlance'].toString(); //赋值金额
                      state.justMessengerCardCode.value =
                          value['data'][0]['crdId'];
                    });
                  },
                  child: Text('刷新卡片信息'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              ),
              Container(
                width: MediaQuery.of(context!).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    ShareDateUtil().setJustMessengerAccount(""); //设置账号为空
                    ShareDateUtil().setJustMessengerPassword(""); //设置密码为空
                    state.isLoginJustMessenger.value = false;
                  },
                  child: Text('取消绑定'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey)),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 初始化一信通
   * [date] 2:00 2024/2/28
   * [param] null
   * [return]
   */
  initJustMessenger() {
    //如果为空那么直接跳过
    if (AccountData.justMessengerAccount.value.isEmpty ||
        AccountData.justMessengerPassword.value.isEmpty) return;

    //直接自动登录
    loginJustMessage(AccountData.justMessengerAccount.value,
        AccountData.justMessengerPassword.value, false);
    AccountData.isLoginJustMessenger.value = true;
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 刷新卡片数据
   * [date] 16:43 2024/9/4
   * [param] null
   * [return]
   */
  refreshCard(){
    if(AccountData.dormCampus.value!="" && AccountData.dormLoudongId.value!="" && AccountData.dormRoom .value!="") {
      PowerDormUtil().getDormPower(AccountData.dormCampus.value, AccountData.dormLoudongId.value, AccountData.dormRoom .value).then((v){
        AccountData.powerMoney.value = v;
      });
    }
  }
  /**
   * [title]
   * [author] 长白崎
   * [description] //TODO 卡片数据
   * [date] 16:41 2024/9/4
   * [param] null
   * [return]
   */
  bindDormCard() {
    return Container(
        // height: ,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //水卡信息

            Obx(() => Column(
              children:
              AccountData.isLoginJustMessenger.value?[
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
                  height: 30,
                  child: Center(child: Text('水卡信息',style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),),),
                ),),
                DashedLind(axis: Axis.horizontal,dashedWidth: 6,count: 30,),
                Container(
                  height: 10,
                ),
               Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child:  Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text('卡号：${AccountData.justMessengerCardCode.value}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),),
                   Text('余额：${AccountData.justMessengerMoney.value}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),)
                 ],
               ),),

              ]:[

              ],
            )),
            //宿舍信息
            Obx(() => Column(
              children: AccountData.powerMoney.value!=""?[
                Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0),child: Container(
                  height: 30,
                  child: Center(child: Text('宿舍信息',style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),),),
                ),),
                DashedLind(axis: Axis.horizontal,dashedWidth: 6,count: 30,),
                Container(
                  height: 10,
                ),
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('校区：${AccountData.dormCampus.value}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),),
                    Text('绑定宿舍：${AccountData.dormLoudongId.value}${AccountData.dormRoom.value}',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),)
                  ],
                ),),
                Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0),child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0),child: Text('电费余额：${AccountData.powerMoney.value}￥',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['main_community_view']!['textColor'] as List )),),)
                  ],
                ),),
              ]:[],
            )),
            Row(
              children: [
                Expanded(child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(0))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '刷新数据',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.refresh,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    refreshCard();
                  },
                ),flex: 1,),
                Expanded(child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(0),bottomRight: Radius.circular(20))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '卡片设置',
                          style: TextStyle(fontSize: 16),
                        ),
                        Icon(
                          Icons.settings,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Get.toNamed(Routes.CardMessageSet);
                  },
                ),flex: 1,),
              ],
            )
          ],
        ));
  }

  @override
  void onInit() {
    getOnClickTotal(); //初始化获取点击统计
    initJustMessenger(); //初始化一信通
    refreshCard(); //刷新卡片数据
  }
}
