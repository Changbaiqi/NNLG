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
            Obx(() => Expanded(
              child: ClassScheduleWidget(
                tableJson: logic.tableJson.value,
                isNoon: true,
                columTimeList: [
                  DateTime(2024,7,15),
                  DateTime(2024,7,16),
                  DateTime(2024,7,17),
                  DateTime(2024,7,18),
                  DateTime(2024,7,19),
                  DateTime(2024,7,20),
                  DateTime(2024,7,21),
                ],
              ),flex: 1,))
          ],
        ),
      ),
    );
  }
}
