import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:share_plus/share_plus.dart';

import '../../dao/CourseData.dart';
import 'logic.dart';

class AccountSafeViewPage extends StatelessWidget {
  AccountSafeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AccountSafeViewLogic>();
  final state = Get.find<AccountSafeViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['backgroundColor'] as List ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        foregroundColor: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['foregroundColor'] as List ),
        iconTheme: IconThemeData(
            color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['defaultIconColor'] as List )
        ),
        title: Text('设置、账号安全及隐私',style: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['textColor'] as List )),),
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
                              style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['textColor'] as List )),
                            ),
                            Text(
                              '您的学号为：${LoginData.account}',
                              style: TextStyle(
                                  fontSize: 15, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['hintTextColor'] as List )),
                            ),
                            Obx(() => Text(
                              '您的密码为：${state.eyeState.value?LoginData.password:'******'}',
                              style: TextStyle(
                                  fontSize: 15, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['hintTextColor'] as List )),
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
                              color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['defaultIconColor'] as List ),
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
            InkWell(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '极速启动',
                              style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['textColor'] as List )),
                            ),
                            Text(
                              '开启将会先进入离线模式快速查看课表，\n其余功能也不会受影响，但是会等待登\n录认证成功后才会准许使用',
                              style: TextStyle(
                                  fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['hintTextColor'] as List )),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Row(
                          children: [
                            // Image.asset('assets/images/end.png',height: 17,width: 17,color: Colors.black45,),
                            Obx(() => Switch(
                                value: ContextDate.isTopSpeedStart.value,
                                onChanged: (v) {
                                  ShareDateUtil().setTopSpeedStart(!ContextDate.isTopSpeedStart.value);
                                }))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                ShareDateUtil().setColorClassSchedule(
                    !CourseData.isColorClassSchedule.value);
              },
            ),
            //颜色主题选择
            Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Container(
                height: 150,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '主题选择',
                                style: TextStyle(fontSize: 20,color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['textColor'] as List )),
                              ),
                              Text(
                                '选择相应的软件主题',
                                style: TextStyle(
                                    fontSize: 10, color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['account_safe_view']!['hintTextColor'] as List )),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),child:  InkWell(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  border: CustomThemeData.selectThemeUid.value=="default:whiteTheme"?Border.all(color: Colors.blueAccent,width: 2):Border.all(color: Colors.transparent,width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 14.0,
                                        spreadRadius: 0,
                                        // color: Color(0xFFdfdfdf)
                                        color: Colors.white24
                                    )
                                  ]
                              ),
                            ),
                            onTap: ()async{
                              await ShareDateUtil().setThemeUid("default:whiteTheme").then((v){
                                CustomThemeData.loadTheme(CustomThemeData.selectThemeUid.value);
                              });
                            },
                          ),),
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 10),child:  InkWell(
                            borderRadius: BorderRadius.circular(50),
                            child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(50),
                                  border: CustomThemeData.selectThemeUid.value=="default:blackTheme"?Border.all(color: Colors.blueAccent,width: 2):Border.all(color: Colors.transparent,width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 14.0,
                                        spreadRadius: 0,
                                        // color: Color(0xFFdfdfdf)
                                        color: Colors.white24
                                    )
                                  ]
                              ),
                            ),
                            onTap: ()async{
                              await ShareDateUtil().setThemeUid("default:blackTheme").then((v){
                                CustomThemeData.loadTheme(CustomThemeData.selectThemeUid.value);
                              });
                            },
                          ),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    ));
  }
}
