import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/dao/AppUpdateData.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/view/module/showNoticeDialog.dart';
import 'package:nnlg/view/module/showUpdateDialog.dart';
import 'state.dart';

class MainViewLogic extends GetxController {
  final MainViewState state = MainViewState();

  animationJumpToPage(int page){
    state.index.value =page;
    state.pageController.value.animateToPage(
        page, duration: Duration(milliseconds: 350),
        curve: Curves.decelerate);
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
