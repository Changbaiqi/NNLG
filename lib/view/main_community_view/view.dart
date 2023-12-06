import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class MainCommunityViewPage extends StatelessWidget {
  const MainCommunityViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<MainCommunityViewLogic>();
    final state = Get.find<MainCommunityViewLogic>().state;

    return Container();
  }
}
