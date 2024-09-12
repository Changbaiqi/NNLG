import 'package:get/get.dart';
import 'package:nnlg/dao/LoginData.dart';

import 'state.dart';

class LoginViewLogic extends GetxController {
  final LoginViewState state = LoginViewState();

  @override
  void onInit() {
    if(LoginData.rememberAccountAndPassword.value){
      state.inputAccountController.value.text = LoginData.account;
      state.inputPasswordController.value.text = LoginData.password;
    }
  }
}
