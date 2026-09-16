import 'package:flutter/material.dart';

/**
 * 统一的滚动行为：
 * - 果冻感来自 Bouncing 弹性回弹（纯位移，避免 shader 拉伸与毛玻璃叠加产生阴影）
 * - 不使用任何越界指示器（发光/拉伸都会在毛玻璃渐变页面上产生阴影跳变）
 */
class CusBehavior extends MaterialScrollBehavior {
  const CusBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const BouncingScrollPhysics(parent: ClampingScrollPhysics());

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
