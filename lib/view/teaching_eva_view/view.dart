import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class TeachingEvaViewPage extends StatelessWidget {
  TeachingEvaViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TeachingEvaViewLogic>();
  final state = Get.find<TeachingEvaViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

        ],
      ),
    );
  }
}
