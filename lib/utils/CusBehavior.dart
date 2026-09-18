import 'package:flutter/material.dart';

/// 全局滚动行为：Material 3 的果冻拉伸效果（参考工墨）
/// - 竖直方向：使用 [StretchingOverscrollIndicator]，拉到边缘继续拉会被"拉扯"回弹
/// - 横向/其它方向：不做越界提示
/// 注意：AppBar 的滚动下陷阴影已在主题里关闭，不会出现阴影跳变
class CusBehavior extends MaterialScrollBehavior {
  const CusBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) =>
      const ClampingScrollPhysics();

  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (details.direction) {
      case AxisDirection.down:
        return StretchingOverscrollIndicator(
            axisDirection: AxisDirection.down, child: child);
      case AxisDirection.up:
        return StretchingOverscrollIndicator(
            axisDirection: AxisDirection.up, child: child);
      default:
        return child;
    }
  }
}
