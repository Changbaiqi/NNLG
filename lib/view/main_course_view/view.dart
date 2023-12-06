import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MainCourseViewPage extends StatelessWidget {
  const MainCourseViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MainCourseViewLogic>();
    final state = Get.find<MainCourseViewLogic>().state;

    return Container();
  }
}
