import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/view/module/ClassScheduleWidget.dart';

import 'logic.dart';

class SoftwareDevelopmentTestViewPage extends StatelessWidget {
  SoftwareDevelopmentTestViewPage({Key? key}) : super(key: key);

  final logic = Get.find<SoftwareDevelopmentTestViewLogic>();
  final state = Get.find<SoftwareDevelopmentTestViewLogic>().state;
  final text = 1.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(child: Obx(() => ClassScheduleWidget(courseJson: text.value,)),flex: 1,)
          ],
        ),
      ),
    );
  }
}
