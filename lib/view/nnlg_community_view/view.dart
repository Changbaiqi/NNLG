import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'logic.dart';

class NnlgCommunityViewPage extends StatelessWidget {
  NnlgCommunityViewPage({Key? key}) : super(key: key);

  final logic = Get.put(NnlgCommunityViewLogic());
  final state = Get.find<NnlgCommunityViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('暂未开放，敬请期待'),),
    );
  }
}
