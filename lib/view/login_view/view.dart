import 'dart:convert';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/AccountUtil.dart';
import 'package:callo/utils/CourseUtil.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/LoginUtil.dart';
import 'package:callo/utils/MainUserUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 登录页：毛玻璃 + 渐变风格
class LoginViewPage extends StatelessWidget {
  LoginViewPage({Key? key}) : super(key: key);

  final logic = Get.find<LoginViewLogic>();
  final state = Get.find<LoginViewLogic>().state;

  static const String _page = 'login_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //学校图标（可点击切换）
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [accent, GlassTheme.lighten(accent, .45)],
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: accent.withValues(alpha: .35),
                          blurRadius: 20,
                          offset: const Offset(0, 10))
                    ],
                  ),
                  child: ClipOval(
                    child: Obx(() => Image.asset(
                          'assets/images/school/${logic.multiData['${logic.selectData[0]}']}.png',
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        )),
                  ),
                ),
                onTap: () {
                  logic.dormPicker();
                },
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Text('点击图标切换学校',
                  style: TextStyle(
                      fontSize: 12.5, color: text.withValues(alpha: .55))),
            ),
            const SizedBox(height: 10),
            inputAccount(),
            inputPassword(),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 10, 50, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => _toggleChip(
                          label: '记住账号密码',
                          checked:
                              LoginData.rememberAccountAndPassword.value,
                          onTap: () {
                            LoginData.rememberAccountAndPassword.value =
                                !LoginData.rememberAccountAndPassword.value;
                            ShareDateUtil().setRememberAccountAndPassword(
                                LoginData.rememberAccountAndPassword.value);
                          },
                        )),
                    Obx(() => _toggleChip(
                          label: '自动登录',
                          checked: LoginData.autoLogin.value,
                          onTap: () {
                            LoginData.autoLogin.value =
                                !LoginData.autoLogin.value;
                            ShareDateUtil().setAutoLogin(
                                LoginData.autoLogin.value);
                          },
                        )),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50, 14, 50, 0),
                child: EasyButton(
                  type: EasyButtonType.elevated,
                  idleStateWidget: Text(
                    '登录',
                    style: TextStyle(
                        color: GlassTheme.scheme.onPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                  loadingStateWidget: CircularProgressIndicator(
                    strokeWidth: 3.0,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        GlassTheme.scheme.onPrimary),
                  ),
                  useWidthAnimation: true,
                  useEqualLoadingStateWidgetDimension: true,
                  width: double.infinity,
                  height: 46.0,
                  borderRadius: 23.0,
                  elevation: 0.0,
                  contentGap: 6.0,
                  buttonColor: accent,
                  onPressed: () async {
                    if (state.inputAccountController.value.text.isEmpty ||
                        state.inputAccountController.value.text.isEmpty) {
                      return;
                    }
                    try {
                      await LoginUtil.turnSubmit(
                              state.inputAccountController.value.text
                                  .toString(),
                              state.inputPasswordController.value.text)
                          .then((value) async {
                        //记住账号密码
                        await LoginUtil().LoginPost(value).then((value) async {
                          if (value['code'] == 200) {
                            ContextDate.ContextCookie =
                                value['session']; //设置session
                            if (LoginData.rememberAccountAndPassword.value) {
                              ShareDateUtil().setLoginAccount(
                                  state.inputAccountController.value.text);
                              ShareDateUtil().setLoginPassword(
                                  state.inputPasswordController.value.text);
                            }

                            //用于获取账户信息并且存储到本地
                            await AccountUtil()
                                .getAccountPersonalInformation()
                                .then((value) async {
                              final dynamic info = jsonDecode(value);
                              print('${info['id']}');

                              //学期列表 + 服务器登录 与本地保存并行执行，缩短等待
                              final Future semesterFuture =
                                  CourseUtil().getSemesterCourseList();
                              MainUserUtil()
                                  .vipLogin('${LoginData.account}',
                                      '${LoginData.password}')
                                  .then((value) {
                                if (value["code"] == 400) {
                                  ToastUtil.show('${value["msg"]}');
                                  return;
                                }

                                if (value["code"] == 200) {
                                  ContextDate.ContextVIPTken = value["token"];
                                  ShareDateUtil().setIsIdent(
                                      value["data"]["user"]["isIdent"] == 1);
                                  ShareDateUtil().setIdentMainColor(
                                      value["data"]["user"]["identMainColor"]);
                                  ShareDateUtil().setIdentMainTag(
                                      value["data"]["user"]["identMainTag"]);
                                }
                              }).catchError((e, s) {
                                //服务器登录失败不影响进入主页，仅记录日志
                                print('vipLogin Exception $e; $s');
                              });

                              await Future.wait([
                                ShareDateUtil()
                                    .setAccountStudentID(info['id']),
                                ShareDateUtil()
                                    .setAccountStudentName(info['name']),
                                ShareDateUtil()
                                    .setAccountStudentMajor(info['major'])
                              ]);
                              //等待学期列表（与上面的服务器登录并行，不再串行等待）
                              await semesterFuture.then((value) {
                                //如果以及寄存了课表的日期那么久直接返回
                                if (CourseData.nowCourseList.value != null &&
                                    CourseData.nowCourseList.value != "")
                                  return;

                                if (value is List && value.isNotEmpty) {
                                  ShareDateUtil().setNowCourseList(value[0]);
                                }
                              });

                              Get.offNamed(Routes.Main);
                            });
                            Get.snackbar("登录提示", "${value['msg']}",
                                duration: const Duration(milliseconds: 1500));
                          } else {
                            Get.snackbar("登录提示", "${value['msg']}",
                                duration: const Duration(milliseconds: 1500));
                          }
                        });
                      });
                    } catch (e) {
                      print(e);
                    }
                  },
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("注",
                        style: TextStyle(color: accent, fontSize: 10)),
                    Text("：账号和密码均为学校教务系统账号和密码",
                        style: TextStyle(
                            color: text.withValues(alpha: .45),
                            fontSize: 11)),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 开关胶囊
  Widget _toggleChip({
    required String label,
    required bool checked,
    required VoidCallback onTap,
  }) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: checked
              ? accent.withValues(alpha: .16)
              : text.withValues(alpha: .05),
          border: Border.all(
            color: checked
                ? accent.withValues(alpha: .60)
                : text.withValues(alpha: .12),
            width: checked ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: checked ? accent : text.withValues(alpha: .45),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: checked ? FontWeight.w700 : FontWeight.w500,
                  color: checked ? accent : text),
            ),
          ],
        ),
      ),
    );
  }

  //账号输入
  Widget inputAccount() {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: state.inputAccountController.value,
                  style: TextStyle(fontSize: 14, color: text),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person_rounded,
                        color: text.withValues(alpha: .55)),
                    labelText: '账号',
                    labelStyle:
                        TextStyle(color: text.withValues(alpha: .65)),
                    hintText: '请输入账号',
                    hintStyle:
                        TextStyle(color: text.withValues(alpha: .45)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(
                            color: text.withValues(alpha: .18))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(100)),
                        borderSide:
                            BorderSide(color: accent, width: 1.4)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //密码输入框
  Widget inputPassword() {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    List<Widget> _seelist = [
      Image.asset('assets/images/close_eye.png',
          height: 25, width: 25, color: text.withValues(alpha: .6)),
      Image.asset('assets/images/open_eye.png',
          height: 25, width: 25, color: text.withValues(alpha: .6)),
    ];
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 12, 40, 0),
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              Expanded(
                child: Obx(() => TextField(
                      controller: state.inputPasswordController.value,
                      obscureText: state.seeNo_Off.value,
                      maxLines: 1,
                      style: TextStyle(fontSize: 14, color: text),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_rounded,
                            color: text.withValues(alpha: .55)),
                        labelText: '密码',
                        labelStyle: TextStyle(
                            color: text.withValues(alpha: .65)),
                        hintText: '请输入密码',
                        hintStyle: TextStyle(
                            color: text.withValues(alpha: .45)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              state.seeNo_Off.value =
                                  !state.seeNo_Off.value;
                            },
                            icon: _seelist[state.seeNo_Off.value ? 0 : 1]),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(100)),
                            borderSide: BorderSide(
                                color: text.withValues(alpha: .18))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                                Radius.circular(100)),
                            borderSide:
                                BorderSide(color: accent, width: 1.4)),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
