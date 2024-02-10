import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class CourseSharedShowViewPage extends StatelessWidget {
  CourseSharedShowViewPage({Key? key}) : super(key: key);

  final logic = Get.find<CourseSharedShowViewLogic>();
  final state = Get.find<CourseSharedShowViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
