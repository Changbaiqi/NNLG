import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:callo/dao/AccountData.dart';
import 'package:callo/dao/AppUpdateData.dart';
import 'package:callo/utils/AccountUtil.dart';
import 'package:callo/view/module/showNoticeDialog.dart';
import 'package:callo/view/module/showUpdateDialog.dart';
import 'state.dart';

class MainViewLogic extends GetxController {
  final MainViewState state = MainViewState();

  /// 点击底部导航切页：直接切换（不做左右滑动动画）
  animationJumpToPage(int page, {bool retry = true}) {
    state.index.value = page;
    final PageController controller = state.pageController.value;
    final ScrollPosition? position = _currentPosition(controller);
    if (position == null) {
      //页面还没挂载时容易被吞掉，下一帧重试一次
      if (retry) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          animationJumpToPage(page, retry: false);
        });
      }
      return;
    }
    _jumpTo(position, page);
    _ensureOnPage(controller, page);
    //兜底：手势/其它滚动打断时再校验一次，保证一定落到目标页
    Future.delayed(const Duration(milliseconds: 80), () {
      _ensureOnPage(controller, page);
    });
  }

  /// 取当前生效的滚动位置。
  /// 用 positions 而不是 position：控制器万一被挂载到多个 PageView 上时，
  /// position 会抛异常导致导航点击"没反应"
  ScrollPosition? _currentPosition(PageController controller) {
    if (controller.positions.isEmpty) return null;
    return controller.positions.last;
  }

  void _jumpTo(ScrollPosition position, int page) {
    final double target = (page * position.viewportDimension)
        .clamp(position.minScrollExtent, position.maxScrollExtent);
    try {
      position.jumpTo(target);
    } catch (_) {
      //忽略：极端情况下 position 已失效
    }
  }

  /// 校验并（必要时）强制跳到目标页
  void _ensureOnPage(PageController controller, int page) {
    final ScrollPosition? position = _currentPosition(controller);
    if (position == null) return;
    final double viewport = position.viewportDimension;
    if (viewport <= 0) return;
    final double current = position.pixels / viewport;
    if ((current - page).abs() > 0.05) {
      _jumpTo(position, page);
    }
  }

  startInit(context)async{
    showNoticeDialog.autoDialog(context);
    showUpdateDialog.autoDialog(context,AppUpdateData.noUpdateVersion.value);
    AccountData.channel = await AccountUtil().onLinetoServer(); //ws在线
  }
  @override
  void onInit() {
    startInit(Get.context!); //初始化
    // state.pageController.value.animateToPage(2, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

}
