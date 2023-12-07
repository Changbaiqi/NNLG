import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/ChitchatUtil.dart';

class ChitChatViewState {
  late ChitchatUtil chitchatUtil;

  BuildContext? context;

  TextEditingController sendTextEdit = TextEditingController();

  final listScrollController = ScrollController().obs;

  final msgList = [].obs;

  int historyMsgNum = 0;


  ChitChatViewState() {
    ///Initialize variables
  }
}
