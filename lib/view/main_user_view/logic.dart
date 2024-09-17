import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import 'state.dart';

class MainUserViewLogic extends GetxController {
  final MainUserViewState state = MainUserViewState();
  BuildContext? showCaseContext;

  final showCase_1 = GlobalKey();

  showEvent()async{
    await Future.delayed(Duration(seconds: 3));
    ShowCaseWidget.of(showCaseContext!).startShowCase([showCase_1]);
  }
  @override
  void onInit() {
    showEvent();
  }
}
