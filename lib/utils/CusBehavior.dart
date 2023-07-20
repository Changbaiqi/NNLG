import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';

/**
 * 消除滑动时缓冲蓝条
 */
class CusBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    if (Platform.isAndroid || Platform.isFuchsia) return child;
    return super.buildOverscrollIndicator(context, child,ScrollableDetails(direction: axisDirection));
  }
}
