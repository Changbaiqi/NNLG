import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/LoginData.dart';
import 'package:callo/view/module/GlassLinkPicker.dart';

import 'state.dart';

class LoginViewLogic extends GetxController {
  final LoginViewState state = LoginViewState();
  final selectData = [].obs;
  Map multiData = {
    '桂林理工大学': "guilinligongdaxue",
    '桂林电子科技大学': "guilindianzikejidaxue",
    '南宁理工学院': "nanningligongxueyuan",
    '广西师范大学': "guangxishifandaxue",
  };

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 测试宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  Future<List<dynamic>> dormPicker() async {
    final List<String>? result = await showGlassLinkPicker(Get.context!,
        data: multiData,
        selectData: selectData.map((e) => '$e').toList(),
        columnNum: 1,
        title: '选择学校',
        page: 'login_view');
    if (result != null && result.isNotEmpty) {
      selectData.value = result;
    }
    return selectData;
  }

  @override
  void onInit() {
    selectData.value = ['桂林理工大学'];
    if (LoginData.rememberAccountAndPassword.value) {
      state.inputAccountController.value.text = LoginData.account;
      state.inputPasswordController.value.text = LoginData.password;
    }
  }
}
