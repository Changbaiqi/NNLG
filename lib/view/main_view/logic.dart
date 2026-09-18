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

  animationJumpToPage(int page) async {
    state.index.value = page;
    final PageController controller = state.pageController.value;
    if (!controller.hasClients) return;
    try {
      await controller.animateToPage(
          page, duration: Duration(milliseconds: 350),
          curve: Curves.decelerate);
    } catch (_) {
      //忽略动画被中断的异常
    }
    //兜底：动画被手势/其它动画打断时，保证页面一定落到目标页，
    //避免出现"底部导航高亮变了但页面卡住不动"
    if (controller.hasClients &&
        controller.page != null &&
        (controller.page! - page).abs() > 0.01) {
      controller.jumpToPage(page);
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
