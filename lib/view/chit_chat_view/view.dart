import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChitChatViewPage extends StatelessWidget {
  const ChitChatViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<ChitChatViewLogic>();
    final state = Get.find<ChitChatViewLogic>().state;

    return Container();
  }
}
