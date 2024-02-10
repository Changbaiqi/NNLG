import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedListViewPage extends StatelessWidget {
  CourseSharedListViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedListViewLogic>();
  final state = Get.find<CourseSharedListViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
