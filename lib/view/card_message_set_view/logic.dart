import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/JustMessengerUtil.dart';
import 'package:callo/utils/PowerDormUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/view/module/GlassLinkPicker.dart';

import 'state.dart';

/**
 * [title]
 * [author] 长白崎
 * [description] //TODO 宿舍选择
 * [date] 20:31 2024/9/3
 */
class CardMessageSetViewLogic extends GetxController {
  final CardMessageSetViewState state = CardMessageSetViewState();
  final selectData = [].obs;

  final TextEditingController inputAccountController = TextEditingController();
  final TextEditingController inputPasswordController = TextEditingController();
  final seeNo_Off = false.obs;

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  Future<List<dynamic>> dormPicker() async {
    final List<String>? result = await showGlassLinkPicker(Get.context!,
        data: PowerDormUtil.dormList(),
        selectData: selectData.map((e) => '$e').toList(),
        columnNum: 3,
        title: '选择宿舍',
        page: 'card_message_set_view');
    if (result != null && result.length >= 3) {
      selectData.value = result;
      ShareDateUtil().setDormCampus(result[0]);
      ShareDateUtil().setDormLoudongId(result[1]);
      ShareDateUtil().setDormRoom(result[2]);
      AccountData.powerMoney.value = await PowerDormUtil()
          .getDormPower(result[0], result[1], result[2]);
    }
    return selectData;
  }

  /**
   * [title]
   * [author] 一信通绑定
   * [description] //TODO
   * [date] 16:45 2024/9/4
   * [param] null
   * [return]
   */
  bingJustMessage() {}

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 登录一信通函数
   * [date] 1:08 2024/2/26
   * [param] null
   * [return]
   */
  loginJustMessage(String account, String password, bool isShowSnackbar,
      {showCxt}) {
    JustMessengerUtil().loginPost(account, password).then((value) async {
      // print(value);
      if (value['resultCode'] != null) {
        if (value['message'] == 'Bad credentials') {
          Get.snackbar('提示', '密码错误',
              duration: const Duration(milliseconds: 1500));
          return false;
        }
        Get.snackbar('提示', value['message'],
            duration: const Duration(milliseconds: 1500));
        return false;
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
      if (isShowSnackbar) {
        Get.snackbar('提示', '登录成功',
            duration: const Duration(milliseconds: 1500));
        AccountData.isLoginJustMessenger.value = true; //设置为成功登录状态
        if (showCxt != null) {
          Navigator.pop(showCxt);
        }
      }
    });
  }

  noJustMessengerCard() {
    final Color text = GlassTheme.textColor('card_message_set_view');
    final Color accent = GlassTheme.accentColor('card_message_set_view');
    List<Widget> _seelist = [
      Image.asset('assets/images/close_eye.png',
          height: 25, width: 25, color: text.withValues(alpha: .6)),
      Image.asset('assets/images/open_eye.png',
          height: 25, width: 25, color: text.withValues(alpha: .6)),
    ];
    return MediaQuery(
        data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 32),
          child: Builder(builder: (ctxt) {
            return GlassCard(
              page: 'card_message_set_view',
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassSectionTitle(
                      page: 'card_message_set_view', title: '校园一信通绑定'),
                  const SizedBox(height: 6),
                  Text(
                    '绑定后可查看水卡余额与卡片信息',
                    style: TextStyle(
                        fontSize: 12, color: text.withValues(alpha: .55)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: inputAccountController,
                    style: TextStyle(fontSize: 13.5, color: text),
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_rounded,
                          color: text.withValues(alpha: .55)),
                      labelText: '账号',
                      labelStyle:
                          TextStyle(color: text.withValues(alpha: .65)),
                      hintText: '请输入校园一信通账号/手机号',
                      hintStyle:
                          TextStyle(color: text.withValues(alpha: .45)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: text.withValues(alpha: .18))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: accent, width: 1.4)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => TextField(
                        controller: inputPasswordController,
                        obscureText: seeNo_Off.value,
                        maxLines: 1,
                        style: TextStyle(fontSize: 13.5, color: text),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock_rounded,
                              color: text.withValues(alpha: .55)),
                          labelText: '密码',
                          labelStyle: TextStyle(
                              color: text.withValues(alpha: .65)),
                          hintText: '请输入校园一信通密码',
                          hintStyle: TextStyle(
                              color: text.withValues(alpha: .45)),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          suffixIcon: IconButton(
                            onPressed: () {
                              seeNo_Off.value = !seeNo_Off.value;
                            },
                            icon: _seelist[seeNo_Off.value ? 0 : 1],
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                  color: text.withValues(alpha: .18))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: accent, width: 1.4)),
                        ),
                      )),
                  const SizedBox(height: 16),
                  GradientButton(
                    text: '绑定',
                    page: 'card_message_set_view',
                    height: 44,
                    onPressed: () async {
                      //检测输入的内容是否为空
                      if (inputAccountController.text.isEmpty ||
                          inputPasswordController.text.isEmpty) {
                        Get.snackbar("提示", "输入的内容不能为空",
                            duration: const Duration(milliseconds: 1500));
                        return;
                      }

                      //登录
                      await loginJustMessage(
                          inputAccountController.text,
                          inputPasswordController.text,
                          true,
                          showCxt: ctxt);
                    },
                  ),
                ],
              ),
            );
          }),
        ));
  }

  @override
  Future<void> onInit() async {
    if (AccountData.dormCampus.value != "" &&
        AccountData.dormLoudongId.value != "" &&
        AccountData.dormRoom.value != "") {
      selectData.add(AccountData.dormCampus.value);
      selectData.add(AccountData.dormLoudongId.value);
      selectData.add(AccountData.dormRoom.value);
      PowerDormUtil()
          .getDormPower(selectData[0], selectData[1], selectData[2])
          .then((v) {
        AccountData.powerMoney.value = v;
      });
    }
  }
}
