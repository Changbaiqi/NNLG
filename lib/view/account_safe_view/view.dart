import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:nnlg/dao/LoginData.dart';

import 'logic.dart';

class AccountSafeViewPage extends StatelessWidget {
  AccountSafeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AccountSafeViewLogic>();
  final state = Get.find<AccountSafeViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('账号安全与隐私'),
      ),
      body: Container(
        child: ListView(
          children: [
            InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 83,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '按住不动查看教务系统密码',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              '您的学号为：${LoginData.account}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            ),
                            Obx(() => Text(
                              '您的密码为：${state.eyeState.value?LoginData.password:'******'}',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black45),
                            )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          children: [
                            Obx(() => Image.asset(
                              state.eyeState.value?'assets/images/open_eye.png':'assets/images/close_eye.png',
                              height: 17,
                              width: 17,
                              color: Colors.black45,
                            ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTapUp: (v){
                // log('false');
                state.eyeState.value = false;
              },
              onTapDown: (v){
                // log('true');
                state.eyeState.value = true;
              },
            ),
          ],
        ),
      ),
    );
  }
}
