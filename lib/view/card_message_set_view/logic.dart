import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:get/get.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/JustMessengerUtil.dart';
import 'package:callo/utils/PowerDormUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';

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
   * [description] TODO 测试宿舍选择弹窗
   * [date] 1:14 2024/2/26
   * [param] null
   * [return]
   */
  List<dynamic> dormPicker() {
    var multiData = {
      '桂林': {
        '7栋': [],
        '8栋': [],
        '9栋': [],
        '10A栋': [],
        '10B栋': [],
        '12栋': [],
        '13栋': [],
        '14A栋': [],
        '14B栋': [],
      },
      '南宁': {
        '13-1栋': [],
        '13-2栋': [],
        '15-1栋': [],
        '15-2栋': [],
        '17栋': [],
        '18栋': [],
        '19栋': [],
        '20栋': [],
        '21栋': [],
        '1号楼': [],
        '2号楼': [],
        '3号楼': [],
        '4号楼': [],
        '5号楼': [],
        '6号楼': [],
        '7号楼': [],
        '8号楼': [],
        '9号楼': [],
        '10号楼': [],
        '11号楼': [],
        '12号楼':[],
        '14号楼': [],
        '16号楼': [],
        '致远楼一单元': [],
        '致远楼二单元': [],
        '德馨楼一单元': [],
        '德馨楼二单元': [],
        '博雅楼一单元': [],
        '博雅楼二单元': [],
      }
    };
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 35; ++y) {
        multiData['桂林']?['7栋']?.add('${x * 100 + y}');
        multiData['桂林']?['8栋']?.add('${x * 100 + y}');
        multiData['桂林']?['9栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10A栋']?.add('${x * 100 + y}');
        multiData['桂林']?['10B栋']?.add('${x * 100 + y}');
        multiData['桂林']?['12栋']?.add('${x * 100 + y}');
      }
    }
    //桂林13栋
    for (int j = 1; j <= 9; ++j)
      for (int i = 1; i <= 8; ++i)
        multiData['桂林']?['13栋']?.add('${j * 100 + i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1101; i <= 1108; ++i) multiData['桂林']?['13栋']?.add('${i}');
    for (int i = 1001; i <= 1008; ++i) multiData['桂林']?['13栋']?.add('${i}');
    //桂林14A栋
    for (int j = 1; j <= 6; ++j)
      for (int i = 1; i <= 64; ++i)
        multiData['桂林']?['14A栋']?.add('${j * 1000 + i}');
    //桂林14B栋
    for (int i = 1066; i <= 1141; ++i) multiData['桂林']?['14B栋']?.add('${i}');
    for (int j = 2; j <= 6; ++j)
      for (int i = 64; i <= 139; ++i)
        multiData['桂林']?['14B栋']?.add('${j * 1000 + i}');

    //南宁校区----



    //13-2栋
    for (int j = 1; j <= 9; ++j){
      for (int i = 40; i <= 88; ++i) {
        multiData['南宁']?['13-2栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 38; i <= 288; ++i) {
      multiData['南宁']?['13-2栋']?.add('${1000 + i}');
    }
    //15-1
    for (int j = 1; j <= 6; ++j) {
      for (int i = 1; i <= 47; ++i) {
        multiData['南宁']?['15-1栋']?.add('${j * 100 + i}');
      }
    }
    //15-2栋
    for (int i = 33; i <= 68; ++i){ multiData['南宁']?['15-2栋']?.add('${100 + i}');}
    for (int j = 2; j <= 6; ++j){
      for (int i = 49; i <= 84; ++i) {
        multiData['南宁']?['15-2栋']?.add('${j * 100 + i}');
      }
    }

    //13-1、17、20、21栋
    for (int j = 1; j <= 9; ++j) {
      for (int i = 1; i <= 36; ++i) {
        multiData['南宁']?['13-1栋']?.add('${j * 100 + i}');
        multiData['南宁']?['17栋']?.add('${j * 100 + i}');
        multiData['南宁']?['20栋']?.add('${j * 100 + i}');
        multiData['南宁']?['21栋']?.add('${j * 100 + i}');
      }
    }
    for (int i = 1; i <= 236; ++i) {
      multiData['南宁']?['13-1栋']?.add('${1000 + i}');
      multiData['南宁']?['17栋']?.add('${1000 + i}');
      multiData['南宁']?['20栋']?.add('${1000 + i}');
      multiData['南宁']?['21栋']?.add('${1000 + i}');
    }
    //18、19栋
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 47; ++y) {
        multiData['南宁']?['18栋']?.add('${x * 100 + y}');
        multiData['南宁']?['19栋']?.add('${x * 100 + y}');
      }
    }

    //1，3号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['1号楼']?.add('${x*100 + y}');
        multiData['南宁']?['3号楼']?.add('${x*100 + y}');
      }
    }
    //2号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['2号楼']?.add('${x*100 + y}');
      }
    }
    for (int y = 1; y <= 48; ++y) {
      multiData['南宁']?['2号楼']?.add('${1100 + y}');
    }

    //4、5、9号楼
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 24; ++y) {
        multiData['南宁']?['4号楼']?.add('${x * 100 + y}');
        multiData['南宁']?['5号楼']?.add('${x * 100 + y}');
      }
    }
    //6号楼
    for (int x = 1; x <= 8; ++x) {
      for (int y = 1; y <= 36; ++y) {
        multiData['南宁']?['6号楼']?.add('${x * 100 + y}');
      }
    }

    //7号楼
    for (int x = 1; x <= 10; ++x) {
      for (int y = 1; y <= 60; ++y) {
        multiData['南宁']?['7号楼']?.add('${x * 100 + y}');
      }
    }

    //8号楼
    for (int x = 1; x <= 6; ++x) {
      for (int y = 1; y <= 48; ++y) {
        multiData['南宁']?['6号楼']?.add('${x * 100 + y}');
      }
    }


    Pickers.showMultiLinkPicker(Get.context!,

        data: multiData,
        selectData: selectData,
        pickerStyle: PickerStyle(
          backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List),
          textColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['textColor'] as List),
            headDecoration: BoxDecoration(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['showBindPowerDialog']!['backgroundColor'] as List))
        ),
        columeNum: 3, onConfirm: (p, covariant) async {
      selectData.value = p;
      ShareDateUtil().setDormCampus(selectData[0]);
      ShareDateUtil().setDormLoudongId(selectData[1]);
      ShareDateUtil().setDormRoom(selectData[2]);
      AccountData.powerMoney.value = await PowerDormUtil()
          .getDormPower(selectData[0], selectData[1], selectData[2]);
    });
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
    List<Widget> _seelist = [
      Image.asset(
        'assets/images/close_eye.png',
        height: 25,
        width: 25,
      ),
      Image.asset(
        'assets/images/open_eye.png',
        height: 25,
        width: 25,
      )
    ];
    BuildContext? showCtxt = null;
    return MediaQuery(data: MediaQuery.of(Get.context!).copyWith(textScaleFactor: 1.0), child: Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 0),
      body: Stack(
        children: [
          InkWell(
            child: Container(
              width: Get.context!.width,
              height: Get.context!.height,
            ),
            onTap: () {
              Navigator.pop(showCtxt!);
            },
          ),
          Builder(
            builder: (ctxt) {
              showCtxt = ctxt;
              return Center(
                child: Container(
                  height: 210,
                  width: 300,
                  decoration: BoxDecoration(
                    // color: Colors.white,
                      color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['backgroundColor'] as List ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                          child: Container(
                            height: 55,
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: inputAccountController,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.person,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List ),),
                                      label: Text('账号',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),),
                                      hintText: '请输入校园一信通账号/手机号',
                                      hintStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),
                                      enabledBorder: OutlineInputBorder(
                                        // borderRadius: BorderRadius.all(
                                        //     Radius.circular(100)
                                        // )
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        // borderRadius: BorderRadius.all(
                                        //     Radius.circular(100)
                                        // )
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            height: 55,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Obx(() => TextField(
                                    controller: inputPasswordController,
                                    obscureText: seeNo_Off.value,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List ),),
                                      label: Text('密码',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),),
                                      hintText: '请输入校园一信通密码',
                                      hintStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),
                                      enabledBorder: OutlineInputBorder(
                                        // borderRadius: BorderRadius.all(
                                        //     Radius.circular(100)
                                        // )
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          seeNo_Off.value =
                                          !seeNo_Off.value;
                                        },
                                        icon: _seelist[
                                        seeNo_Off.value ? 0 : 1],color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List ),),
                                      focusedBorder: OutlineInputBorder(
                                        // borderRadius: BorderRadius.all(
                                        //     Radius.circular(100)
                                        // )
                                      ),
                                    ),
                                    /*onChanged: (password){
                    _password = password;
                  },*/
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Container(
                            width: MediaQuery.of(Get.context!).size.width,
                            height: 45,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['foregroundColor'] as List ))
                              ),
                              child: Text('校园一信通绑定',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),),
                              onPressed: () async {
                                //检测输入的内容是否为空
                                if (inputAccountController.text.isEmpty ||
                                    inputPasswordController.text.isEmpty) {
                                  Get.snackbar("提示", "输入的内容不能为空",
                                      duration:
                                      const Duration(milliseconds: 1500));
                                  return;
                                }

                                //登录
                                bool state = await loginJustMessage(
                                    inputAccountController.text,
                                    inputPasswordController.text,
                                    true,
                                    showCxt: showCtxt);
                                // _testPicker();
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
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
