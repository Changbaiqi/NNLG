
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:nnlg/utils/ChitchatUtil.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChitChatViewState {
  late ChitchatUtil chitchatUtil;

  BuildContext? context;

  TextEditingController sendTextEdit = TextEditingController();

  final listScrollController = ScrollController().obs;

  final RefreshController refreshController = RefreshController(initialRefresh: false);

  final msgList = [].obs;

  int historyMsgNum = 0;

  final audioPlayer = AudioPlayer();


  ChitChatViewState() {
    ///Initialize variables
  }
}
