import 'dart:developer';

import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:callo/dao/LoginData.dart';

import '../../utils/PowerDormUtil.dart';
import 'state.dart';

class LoginViewLogic extends GetxController {
  final LoginViewState state = LoginViewState();
  final selectData = [].obs;
  Map multiData = {
    '桂林理工大学':"guilinligongdaxue",
    '桂林电子科技大学':"guilindianzikejidaxue",
    '南宁理工学院':"nanningligongxueyuan",
    '广西师范大学':"guangxishifandaxue",
  };
  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 测试宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  List<dynamic> dormPicker() {

    Pickers.showMultiLinkPicker(Get.context!,

        data: multiData,
        selectData: selectData,
        pickerStyle: PickerStyle(
            backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List),
            textColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List),
            headDecoration: BoxDecoration(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List))
        ),
        columeNum: 1, onConfirm: (p, covariant) async {
          selectData.value = p;

          print(covariant);
        });
    return selectData;
  }

  @override
  void onInit() {
    selectData.value = ['桂林理工大学'];
    if(LoginData.rememberAccountAndPassword.value){
      state.inputAccountController.value.text = LoginData.account;
      state.inputPasswordController.value.text = LoginData.password;
    }
  }
}
