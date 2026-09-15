import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:callo/dao/AppInfoData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 启动页：毛玻璃 + 渐变风格（保留原有动画逻辑）
class StartViewPage extends StatelessWidget {
  const StartViewPage({Key? key}) : super(key: key);

  static const String _page = 'start_view';

  @override
  Widget build(BuildContext context) {
    final logic = Get.find<StartViewLogic>();
    final state = Get.find<StartViewLogic>().state;
    final Color text = GlassTheme.textColor(_page);

    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            //中央 Logo 与加载动画
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
            //底部提示与跳过按钮
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 200),
                child: Obx(() => Opacity(
                      opacity: logic.tipsOp.value!.value,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '可能教务系统同时使用人数过多，正在登录请您耐心等待...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: text.withValues(alpha: .6)),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: 210,
                            child: GradientButton(
                              text: '跳过同步直接进入',
                              page: _page,
                              height: 42,
                              onPressed: () {
                                Get.offNamed(Routes.Main);
                              },
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            //版本信息
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 80,
                child: Obx(() => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${AppInfoData.version.value}(${AppInfoData.versionNumber.value})",
                          style: TextStyle(
                              fontSize: 12,
                              color: text.withValues(alpha: .35)),
                        ),
                        Text('By.ChangBaiQi',
                            style: TextStyle(
                                fontSize: 12,
                                color: text.withValues(alpha: .35)))
                      ],
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
