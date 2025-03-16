import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginViewState {
  final inputAccountController = TextEditingController().obs;
  final inputPasswordController = TextEditingController().obs;
  final seeNo_Off = true.obs;
  final loginState = false.obs; //false代表正常，true代表登录中
  LoginViewState() {
    ///Initialize variables
  }
}
