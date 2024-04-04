import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'logic.dart';

class MainCourseNewViewPage extends StatelessWidget {
  MainCourseNewViewPage({Key? key}) : super(key: key);

  final logic = Get.find<MainCourseNewViewLogic>();
  final state = Get.find<MainCourseNewViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SfCalendar(),
      ),
    );
  }
}
