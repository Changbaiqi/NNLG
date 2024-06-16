import 'dart:async';
import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/ContextData.dart';
import 'package:nnlg/dao/CourseData.dart';
import 'package:nnlg/dao/LoginData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/utils/CourseUtil.dart';
import 'package:nnlg/utils/LoginUtil.dart';
import 'package:nnlg/utils/MainUserUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:nnlg/utils/ToastUtil.dart';
import 'package:nnlg/view/router/Routes.dart';

import 'state.dart';

class StartViewLogic extends GetxController with SingleGetTickerProviderMixin {
  final StartViewState state = StartViewState();

  AnimationController? logoAnimationController; //动画控制器
  AnimationController? loadAnimationController; //动画控制器
  AnimationController? tipsAnimationController; //提示文字动画控制器

  final logoOp = Rx<Animation<double>?>(null); //logo透明度
  final logoScaleTransition = Rx<Animation<double>?>(null); //logo大小变换

  final loadOp = Rx<Animation<double>?>(null); //加载动画透明度
  final loadScaleTransition = Rx<Animation<double>?>(null); //加载动画大小变换

  final tipsOp = Rx<Animation<double>?>(null); //文字动画透明度

  Animation<double>? scale;

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 初始化动画
   * [date] 20:42 2024/2/22
   * [param] null
   * [return]
   */
  initAnimation() {
    logoAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    logoOp.value = Tween(begin: 0.0, end: 1.0).animate(logoAnimationController!)
      ..addListener(() {
        logoOp.refresh();
      });
    logoScaleTransition.value =
        Tween(begin: 0.8, end: 1.0).animate(logoAnimationController!)
          ..addListener(() {
            logoScaleTransition.refresh();
          });

    loadAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    loadOp.value = Tween(begin: 0.0, end: 1.0).animate(loadAnimationController!)
      ..addListener(() {
        loadOp.refresh();
      });
    loadScaleTransition.value =
        Tween(begin: 0.8, end: 1.0).animate(loadAnimationController!)
          ..addListener(() {
            loadScaleTransition.refresh();
          });

    tipsAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    tipsOp.value = Tween(begin: 0.0, end: 1.0).animate(tipsAnimationController!)
      ..addListener(() {
        tipsOp.refresh();
      });

    logoAnimationController!.forward();
    //如果5秒过后还没进去，那么启用加载动画
    Future.delayed(const Duration(seconds: 5), () {
      logoAnimationController!.reverse().then((value) {
        loadAnimationController!.repeat(reverse: true);
        tipsAnimationController!.forward();
      });
    });
    // animationController!.forward();
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 初始化本地数据并且自动登录
   * [date] 21:05 2024/2/22
   * [param] null
   * [return]
   */
  initShareDate() {
    ShareDateUtil().initLoading().then((value) async {
      //print('${CourseData.nowWeek}');

      if (LoginData.autoLogin.value &&
          LoginData.account.isNotEmpty &&
          LoginData.password.isNotEmpty) {
        //自动登录用的
        LoginUtil.turnSubmit(LoginData.account, LoginData.password)
            .then((value) {
          //debugPrint(value);

          //记住账号密码
          LoginUtil().LoginPost(value).then((value) async {
            if (value['code'] == 200) {
              ToastUtil.show('${value['msg']}');
              ContextDate.ContextCookie = value['session'];

              //进行完课表拉取后然后进行对应课表数据拉取刷新
              Future.wait([
                CourseUtil().getSemesterCourseList(),
                CourseUtil()
                    .getAllCourseWeekList("${CourseData.nowCourseList.value}")
              ]).then((value) {});

              //服务器功能上线
              MainUserUtil()
                  .vipLogin('${LoginData.account}', '${LoginData.password}')
                  .then((value) {
                if (value["code"] == 400) {
                  ToastUtil.show('${value["msg"]}');
                  return;
                }

                if (value["code"] == 200) {
                  ContextDate.ContextVIPTken = value["token"];
                  ShareDateUtil().setIsIdent(value["data"]["user"]["isIdent"]==1); //设置是否有认证
                  ShareDateUtil().setIdentMainColor(value["data"]["user"]["identMainColor"]); //设置主认证颜色
                  log("认证颜色：${value["data"]["user"]["identMainColor"]}");
                  ShareDateUtil().setIdentMainTag(value["data"]["user"]["identMainTag"]); //设置主认证标签
                }
              });

              toMain();
            } else {
              ToastUtil.show('${value['msg']}');
              toLogin();
            }
          });
        });
      } else {
        toLogin();
      }
    });
  }

  @override
  void onInit() {
    initShareDate();
    initAnimation();
    toClick();
  }

  void toLogin() {
    Timer timer = Timer(Duration(seconds: 1), () {
      Get.offNamed(Routes.Login);
    });
  }

  void toMain() {
    Timer timer = Timer(Duration(seconds: 1), () {
      Get.offNamed(Routes.Main);
    });
  }

  /**
   * 用于统计软件点击次数
   */
  void toClick() {
    AccountUtil().toOnclickTotal();
  }
}
