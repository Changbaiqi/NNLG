import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MainWaterViewPage extends StatelessWidget {
  const MainWaterViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MainWaterViewLogic>();
    final state = Get.find<MainWaterViewLogic>().state;

    return Container();
  }
}
