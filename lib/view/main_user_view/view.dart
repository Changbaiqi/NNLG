import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/AppUpdateData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/HexColor.dart';
import 'package:nnlg/utils/MainUserUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/utils/UserHeadPortraitUtil.dart';
import 'package:nnlg/utils/edusys/Account.dart';
import 'package:nnlg/view/VIPFunList.dart';
import 'package:nnlg/view/module/showUpdateDialog.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'logic.dart';

class MainUserViewPage extends StatelessWidget {
  MainUserViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainUserViewLogic());
  final state = Get.find<MainUserViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 40, 10, 0),
                child: Card(
                  child: Container(
                    // height: 470,
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  'assets/images/black.webp',
                                  fit: BoxFit.fill,
                                  height: 220,
                                  width: MediaQuery.of(context).size.width,
                                ),
                                Container(
                                  height: 1,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                            Obx(() => Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          child: Container(
                                            height: 130,
                                            width: 130,
                                            child: Stack(
                                              children: [
                                                ClipOval(
                                                  //child: Image.asset('images/user.jpg',height: 130,width: 130,),
                                                  child: AccountData
                                                      .headMode.value ==
                                                      0
                                                      ? Image.network(
                                                      "https://q1.qlogo.cn/g?b=qq&nk=2084069833&s=640",
                                                      height: 130,
                                                      width: 130,fit: BoxFit.cover
                                                  )
                                                      : (AccountData.headMode
                                                      .value ==
                                                      1
                                                      ? Image.network(
                                                      "https://q1.qlogo.cn/g?b=qq&nk=${AccountData.head_qq.value}&s=640",
                                                      height: 130,
                                                      width: 130,
                                                      errorBuilder:
                                                          (contex, e,
                                                          stak) {
                                                        return Image
                                                            .network(
                                                            "https://q1.qlogo.cn/g?b=qq&nk=2084069833&s=640",
                                                            height: 130,
                                                            width: 130,fit: BoxFit.cover
                                                        );
                                                      },fit: BoxFit.cover
                                                  )
                                                      : Image.file(
                                                    File(AccountData
                                                        .head_filePath
                                                        .value),
                                                    height: 130,
                                                    width: 130,fit: BoxFit.cover,
                                                  )),
                                                ),
                                                Visibility(
                                                    visible: AccountData
                                                        .isIdent.value,
                                                    child: Positioned(
                                                      child: Icon(
                                                        Icons.verified,
                                                        color: HexColor(
                                                            AccountData
                                                                .identMainColor
                                                                .value),
                                                        size: 35,
                                                      ),
                                                      bottom: 0,
                                                    ))
                                              ],
                                            ),
                                          ),
                                          onLongPress: () {
                                            HapticFeedback.vibrate();
                                            MainUserUtil()
                                                .vipLogin(
                                                    '${LoginData.account}',
                                                    '${LoginData.password}')
                                                .then((value) {
                                              if (value["code"] == 400) {
                                                ToastUtil.show(
                                                    '${value["msg"]}');
                                                return;
                                              }

                                              if (value["code"] == 200) {
                                                ContextDate.ContextVIPTken =
                                                    value["token"];
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (builder) {
                                                  return VIPFunList();
                                                }));
                                              }
                                            });
                                          },
                                          onTap: () async {
                                            UserHeadPortraitUtil u =
                                                UserHeadPortraitUtil(context);
                                            await u.setHead().then((value) {
                                            });
                                          },
                                        ),
                                        Text(
                                          '${AccountData.studentName}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(visible: AccountData.isIdent.value,child: Card(
                                  child: Container(
                                    height: 40,
                                    width:
                                    MediaQuery.of(context).size.width,
                                    padding:
                                    EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: HexColor(AccountData
                                              .identMainColor.value),
                                          size: 20,
                                        ),
                                        Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),child: Text('${AccountData.identMainTag}'),)
                                      ],
                                    ),
                                  ),
                                )),
                                Card(
                                  child: Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    child: Row(
                                      children: [
                                        Text('学号：${AccountData.studentID}')
                                      ],
                                    ),
                                  ),
                                ),
                                Card(
                                  child: Container(
                                    height: 40,
                                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        Text('专业方向：${AccountData.studentMajor}')
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    //课表设置
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '关于软件和作者',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SvgPicture.asset(
                                    'assets/images/about.svg',
                                    width: 30,
                                    height: 30,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // print('课表设置');
                              Get.toNamed(Routes.AboutMe);
                            },
                          ),
                        ),
                      ),
                    ),
                    //探索新版
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '探索新版',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Image.asset(
                                    'assets/images/bbgx.png',
                                    width: 29,
                                    height: 29,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              //print('探索新版本');
                              //ToastUtil.show('功能暂未开放');
                              //ToastUtil.show('${AppInfoData.buildNumber}');
                              //检测是否为最新版
                              showUpdateDialog.isLastVersion().then((value) {
                                if (value == true)
                                  Get.snackbar(
                                    "更新提示",
                                    "已经是最新版啦(～￣▽￣)～ ",
                                    duration: Duration(milliseconds: 1500),
                                  );
                                else
                                  showUpdateDialog.autoDialog(context, -1);
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    //账号安全与隐私
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '账号安全与隐私',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: SvgPicture.asset('assets/images/safe.svg',height: 25,width: 25,),
                                  // child: Image.asset(
                                  //   'assets/images/backLogin.png',
                                  //   width: 25,
                                  //   height: 25,
                                  // ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.toNamed(Routes.AccountSafe);
                            },
                          ),
                        ),
                      ),
                    ),
                    //退出登录
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '退出登录',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Image.asset(
                                    'assets/images/backLogin.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              //退出登录
                              ShareDateUtil().clearAllAccountData();
                              Get.offNamed(Routes.Login);
                            },
                          ),
                        ),
                      ),
                    ),

                    //用于软件测试的入口
                    Visibility(child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    '软件开发测试',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                  child: Image.asset(
                                    'assets/images/backLogin.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              //进入软件测试页面
                              Get.toNamed(Routes.SoftwareDevelopmentTestView);
                            },
                          ),
                        ),
                      ),
                    ),visible: true,)
                  ],
                ),
              )
            ],
          )),
    );
  }
}
