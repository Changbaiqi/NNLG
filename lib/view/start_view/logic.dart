import 'dart:async';
import 'dart:developer';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/AccountUtil.dart';
import 'package:callo/utils/LoginUtil.dart';
import 'package:callo/utils/MainUserUtil.dart';
import 'package:callo/utils/ShareDateUtil.dart';
import 'package:callo/utils/ToastUtil.dart';
import 'package:callo/view/router/Routes.dart';

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
    Future.delayed(const Duration(seconds: 5), showSkipTips);
    // animationController!.forward();
  }

  bool _skipTipsShown = false;

  /// 展示加载动画与「跳过同步直接进入」按钮（5秒后或登录异常时）
  void showSkipTips() {
    if (_skipTipsShown) return;
    if (loadAnimationController == null || tipsAnimationController == null) {
      return;
    }
    _skipTipsShown = true;
    logoAnimationController!.reverse().then((value) {
      loadAnimationController!.repeat(reverse: true);
      tipsAnimationController!.forward();
    });
  }

  /**
   * [title] 初始化本地数据并且自动登录
   * [description] 自动登录优先使用上次登录保存的会话：
   * 1.本地有该账号上次保存的 Cookie/Token 时，直接用它进入主页，
   *   课表等数据用该会话在后台同步（教务系统登录很慢也不影响进入）；
   *   若会话已过期，业务请求会自动重新登录并重试
   * 2.本地没有会话（首次登录/已退出登录）时走正常登录，
   *   等待过程中可以手动「跳过同步直接进入」，登录在后台继续
   */
  initShareDate() async {
    await ShareDateUtil().initLoading();
    if (LoginData.autoLogin.value &&
        LoginData.account.isNotEmpty &&
        LoginData.password.isNotEmpty) {
      autoLogin();
    } else {
      toLogin();
    }
  }

  /// 自动登录
  void autoLogin() {
    //服务器功能（认证信息等）与本机教务登录无关，独立在后台完成
    _vipLogin();
    if (ContextDate.ContextCookie.isNotEmpty) {
      //本地有上次登录的会话：直接进入主页。
      //会话是否有效由课表同步请求自动验证：有效就直接刷新课表，
      //过期（提示"请先登录系统"）会自动重新登录并重试，全程不阻塞进入
      toMain();
      return;
    }
    if (ContextDate.isTopSpeedStart.value) {
      //极速启动且本地没有会话：先进入主页，登录在后台继续
      _doAutoLogin();
      toMain();
      return;
    }
    //本地没有会话（首次登录/已退出登录）：走正常登录，等待中可手动跳过
    _doAutoLogin();
  }

  /// 账号密码登录（首次登录或本地没有可用会话时）
  Future<void> _doAutoLogin() async {
    try {
      //与业务请求触发的重新登录共用同一个请求，避免重复登录互相顶掉会话
      final Map<String, dynamic> result =
          await LoginUtil.loginOnce(LoginData.account, LoginData.password);
      if (result['code'] == 200) {
        ContextDate.ContextCookie = result['session'];
        //按账号保存会话，下次启动可以直接使用
        ShareDateUtil().setCookie(result['session']);
        toMain();
        return;
      }
      //账号或密码错误：提示后回登录页
      ToastUtil.show('${result['msg']}');
      toLogin();
    } catch (e) {
      //超时/网络异常：立即展示「跳过同步直接进入」，由用户决定
      log('自动登录失败: $e');
      ToastUtil.show('教务系统暂时无响应，可点击下方按钮跳过同步直接进入');
      showSkipTips();
    }
  }

  /// 服务器功能上线（认证信息等），后台完成
  Future<void> _vipLogin() async {
    try {
      final value = await MainUserUtil()
          .vipLogin('${LoginData.account}', '${LoginData.password}');
      if (value["code"] == 400) {
        ToastUtil.show('${value["msg"]}');
        return;
      }
      if (value["code"] == 200) {
        ContextDate.ContextVIPTken = value["token"];
        ShareDateUtil().setVipToken(value["token"]); //按账号保存Token
        ShareDateUtil().setIsIdent(value["data"]["user"]["isIdent"] == 1); //设置是否有认证
        ShareDateUtil()
            .setIdentMainColor(value["data"]["user"]["identMainColor"]); //设置主认证颜色
        log("认证颜色：${value["data"]["user"]["identMainColor"]}");
        ShareDateUtil()
            .setIdentMainTag(value["data"]["user"]["identMainTag"]); //设置主认证标签
      }
    } catch (e) {
      log('VIP登录失败: $e');
    }
  }

  @override
  Future<void> onInit() async {
    initShareDate();
    initAnimation();
    toClick();
  }

  void toLogin() {
    //延迟缩短到 300ms：只保留入场动画的缓冲，避免无谓等待
    Timer(const Duration(milliseconds: 300), () {
      //用户已经"跳过同步直接进入主页"时，不再强制跳转登录页，
      //同步完成只需刷新本地 token/cookie 即可
      if (Get.currentRoute != Routes.Start) return;
      Get.offNamed(Routes.Login);
    });
  }

  void toMain() {
    //延迟缩短到 300ms：登录/同步一完成就尽快进入主页
    Timer(const Duration(milliseconds: 300), () {
      //已经在主页时不再重复跳转：否则会重新加载一遍主页，
      //并导致底部导航（PageController 重复挂载）点击失效
      if (Get.currentRoute == Routes.Main) return;
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
