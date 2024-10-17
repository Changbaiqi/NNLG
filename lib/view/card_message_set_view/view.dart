import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/CustomThemeData.dart';
import 'package:nnlg/utils/CustomerThemeUtil.dart';
import 'package:nnlg/view/card_message_set_view/state.dart';

import 'logic.dart';

class CardMessageSetViewPage extends StatelessWidget {
  CardMessageSetViewPage({Key? key}) : super(key: key);

  final CardMessageSetViewLogic logic = Get.put(CardMessageSetViewLogic());
  final CardMessageSetViewState state = Get.find<CardMessageSetViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['backgroundColor'] as List ),
      appBar: AppBar(

        title: Text(
          '卡片设置',
          style: TextStyle(fontSize: 20, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),
        ),
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List )
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['foregroundColor'] as List ),
      ),
      body: ListView(
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '水卡绑定',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '${AccountData.justMessengerAccount.value.isEmpty?"点击此处绑定水卡":"当前绑定账号：${AccountData.justMessengerAccount.value}"}',
                            style: TextStyle(
                                fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['hintTextColor'] as List )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List ),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              showDialog(context: context, builder: (builder){
                return logic.noJustMessengerCard();
              });
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '宿舍绑定',
                            style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['textColor'] as List )),
                          ),
                          Text(
                            '${logic.selectData.value.length!=3?"点击此处绑定宿舍":"当前绑定宿舍：${AccountData.dormLoudongId}${AccountData.dormRoom}"}',
                            style: TextStyle(
                                fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['hintTextColor'] as List )),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: Row(
                        children: [
                          Icon(Icons.dynamic_form_outlined,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['card_message_set_view']!['defaultIconColor'] as List ),)
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            onTap: () {
              logic.dormPicker();
            },
          ),
        ],
      ),
    ));
  }
}
