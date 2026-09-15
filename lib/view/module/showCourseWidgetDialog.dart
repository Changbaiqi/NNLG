import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';
import 'package:callo/utils/CustomerThemeUtil.dart';

/// 与原生 MainActivity 通信的快捷方式通道
const MethodChannel _shortcutChannel =
    MethodChannel('com.cbq.callocollege/shortcut');

/// 冷启动时通过「长按图标 → 添加课表小组件」进入的标记，等界面就绪后再消费
bool _pendingShortcutAddWidget = false;

/// 初始化 App Shortcut 监听（长按桌面图标 → 添加课表小组件），App 启动时调用一次
void initCourseWidgetShortcut() {
  //热启动：原生 onNewIntent 收到快捷方式后主动通知
  _shortcutChannel.setMethodCallHandler((call) async {
    if (call.method == 'addWidgetShortcut') {
      _pendingShortcutAddWidget = false;
      if (Get.context != null) {
        showCourseWidgetDialog();
      } else {
        _pendingShortcutAddWidget = true;
        _scheduleShortcutFallback();
      }
    }
    return null;
  });

  //冷启动：原生在引擎初始化时记录了快捷方式意图
  _shortcutChannel.invokeMethod<bool>('consumeAddWidget').then((pending) {
    if (pending == true) {
      _pendingShortcutAddWidget = true;
      _scheduleShortcutFallback();
    }
  }).catchError((e) {
    print('课表小组件快捷方式监听失败: $e');
  });
}

/// 冷启动兜底：课表页没有及时消费（未登录、停留启动页等）时，界面就绪后直接弹引导
void _scheduleShortcutFallback({int attempt = 0}) {
  if (attempt > 5) return;
  Future.delayed(const Duration(seconds: 3), () {
    if (!_pendingShortcutAddWidget) return;
    if (Get.context == null) {
      _scheduleShortcutFallback(attempt: attempt + 1);
      return;
    }
    _pendingShortcutAddWidget = false;
    showCourseWidgetDialog();
  });
}

/// 冷启动场景下由课表页调用，返回是否需要弹出添加小组件引导
bool consumePendingCourseWidgetDialog() {
  if (!_pendingShortcutAddWidget) return false;
  _pendingShortcutAddWidget = false;
  return true;
}

/// 桌面课表小组件添加引导弹窗
void showCourseWidgetDialog() {
  final Color textColor = CustomerThemeUtil.setColor(
      CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List);
  final Color bgColor = CustomerThemeUtil.setColor(
      CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List);
  final Color accentColor = CustomerThemeUtil.setColor(CustomThemeData
      .nowThemeData
      .value['main_course_view']!['todayCourseItemColor']['borderColor'] as List);

  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: .35),
    builder: (dialogContext) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: EdgeInsets.fromLTRB(20, 22, 20, 16),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: .12),
                      blurRadius: 18,
                      offset: Offset(0, 6))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(14)),
                  child:
                      Icon(Icons.widgets_rounded, color: accentColor, size: 26),
                ),
                SizedBox(height: 14),
                Text('桌面课表小组件',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
                SizedBox(height: 10),
                Text(
                  '把今日课表放到桌面，随时查看\n自动更新 · 上课中高亮 · 跟随主题配色',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.6,
                      color: textColor.withValues(alpha: .7)),
                ),
                SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child:
                              Text('取消', style: TextStyle(color: textColor))),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: accentColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          await CourseWidgetUtil.updateCourseWidget();
                          final bool supported =
                              await CourseWidgetUtil.requestAddWidget();
                          _showAddDesktopGuide(pinSupported: supported);
                        },
                        child: Text('添加到桌面'),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// 添加结果引导：国产系统（如 MIUI）桌面不支持一键添加时会静默失败，这里给出手动添加步骤
void _showAddDesktopGuide({required bool pinSupported}) {
  final Color textColor = CustomerThemeUtil.setColor(
      CustomThemeData.nowThemeData.value['main_course_view']!['textColor'] as List);
  final Color bgColor = CustomerThemeUtil.setColor(
      CustomThemeData.nowThemeData.value['main_course_view']!['backgroundColor'] as List);
  final Color accentColor = CustomerThemeUtil.setColor(CustomThemeData
      .nowThemeData
      .value['main_course_view']!['todayCourseItemColor']['borderColor'] as List);

  final String tips = pinSupported
      ? '已发起添加到桌面，请在系统弹窗中确认。\n\n如果没有弹出系统窗口或桌面无反应（小米/MIUI 等部分系统不支持一键添加），请手动添加：\n1. 长按桌面空白处\n2. 点击「添加小组件」\n3. 搜索「恰啰校园」或找到「今日课表」\n4. 拖到桌面即可\n\n提示：也可以长按桌面上的「恰啰校园」图标，选择「添加课表小组件」'
      : '当前系统桌面不支持一键添加，请手动添加：\n1. 长按桌面空白处\n2. 点击「添加小组件」\n3. 搜索「恰啰校园」或找到「今日课表」\n4. 拖到桌面即可\n\n提示：也可以长按桌面上的「恰啰校园」图标，选择「添加课表小组件」';

  showDialog(
    context: Get.context!,
    barrierColor: Colors.black.withValues(alpha: .35),
    builder: (dialogContext) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 300,
            padding: EdgeInsets.fromLTRB(20, 22, 20, 16),
            decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: .12),
                      blurRadius: 18,
                      offset: Offset(0, 6))
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(14)),
                  child: Icon(
                      pinSupported
                          ? Icons.touch_app_rounded
                          : Icons.info_outline_rounded,
                      color: accentColor,
                      size: 26),
                ),
                SizedBox(height: 14),
                Text(pinSupported ? '已请求添加' : '请手动添加',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: textColor)),
                SizedBox(height: 10),
                Text(
                  tips,
                  style: TextStyle(
                      fontSize: 12.5,
                      height: 1.6,
                      color: textColor.withValues(alpha: .8)),
                ),
                SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text('知道了'),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
