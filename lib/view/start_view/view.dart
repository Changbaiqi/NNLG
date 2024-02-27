import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
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
                child: Stack(
                  children: [
                    Obx(
                      () => ScaleTransition(
                        scale: logic.logoScaleTransition.value!,
                        child: Opacity(
                          opacity: logic.logoOp.value!.value,
                          child: Image.asset(
                            'assets/images/NNLG.png',
                            height: 230,
                            width: 230,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    // ScaleTransition(scale: logic.scale!,child: Image.asset('assets/images/NNLG.png',height: 230,width: 230,fit: BoxFit.fill,),),
                    Obx(() => ScaleTransition(
                          scale: logic.logoScaleTransition.value!,
                          child: Opacity(
                            opacity: logic.loadOp.value!.value,
                            child: LottieBuilder.asset(
                              'assets/images/rocketLoading_lottie.json',
                              height: 230,
                              width: 230,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Opacity(
              opacity: 1,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 200),
                child: Container(
                  height: 30,
                  child: Column(
                    children: [
                      Obx(() => Opacity(
                            opacity: logic.tipsOp.value!.value,
                            child: Text(
                              '可能教务系统同时使用人数过多，正在登录请您耐心等待...',
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 80,
              child: Obx(() => Column(
                    children: [
                      Text(
                        "${AppInfoData.version.value}(${AppInfoData.versionNumber.value})",
                        style: TextStyle(color: Colors.black26),
                      ),
                      Text('By.ChangBaiQi',
                          style: TextStyle(color: Colors.black26))
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
