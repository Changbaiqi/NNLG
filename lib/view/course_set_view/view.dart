import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class CourseSetViewPage extends StatelessWidget {
  const CourseSetViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<CourseSetViewLogic>();
    final state = Get.find<CourseSetViewLogic>().state;

    return Container();
  }
}
