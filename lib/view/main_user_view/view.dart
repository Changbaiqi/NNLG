import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MainUserViewPage extends StatelessWidget {
  const MainUserViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MainUserViewLogic>();
    final state = Get.find<MainUserViewLogic>().state;

    return Container();
  }
}
