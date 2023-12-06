import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedViewPage extends StatelessWidget {
  const CourseSharedViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CourseSharedViewLogic>();
    final state = Get.find<CourseSharedViewLogic>().state;

    return Container();
  }
}
