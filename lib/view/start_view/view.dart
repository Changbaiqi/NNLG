import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nnlg/dao/AppInfoData.dart';
import 'package:nnlg/view/start_view/binding.dart';

import 'logic.dart';

class StartViewPage extends StatelessWidget {
  const StartViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StartViewLogic>();
    final state = Get.find<StartViewLogic>().state;

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Container(
                height: 230,
                width: 230,
                child: Image.asset('assets/images/NNLG.png'),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              child: Obx(() => Column(
                children: [
                  Text("${AppInfoData.version.value}(${AppInfoData.versionNumber.value})",style: TextStyle(color: Colors.black26),),
                  Text('By.ChangBaiQi',style: TextStyle(color: Colors.black26))
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

}
