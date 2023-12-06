import 'package:get/get.dart';
import 'package:nnlg/utils/AccountUtil.dart';
import 'package:nnlg/view/module/showNoticeDialog.dart';
import 'package:nnlg/view/module/showUpdateDialog.dart';
import 'state.dart';

class MainViewLogic extends GetxController {
  final MainViewState state = MainViewState();

  startInit(context){
    showNoticeDialog.autoDialog(context);
    showUpdateDialog.autoDialog(context);
    AccountUtil().onLinetoServer();
  }
  @override
  void onInit() {

  }
}
