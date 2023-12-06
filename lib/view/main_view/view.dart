import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MainViewPage extends StatelessWidget {
  const MainViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MainViewLogic>();
    final state = Get.find<MainViewLogic>().state;

    return Container();
  }
}
