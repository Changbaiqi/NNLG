import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 开发者调试开关
/// 在「关于软件和作者」页面连续点击「恰啰校园」图标 5 次，
/// 可切换「我的」页面中「软件开发测试」入口的显示/隐藏
class DebugData {
  static const String _keyShowDevTest = 'debug_show_dev_test';

  /// 是否显示「软件开发测试」入口（默认关闭）
  static final showDevTest = false.obs;

  /// 连续点击计数与上次点击时间（用于连点判定）
  static int _tapCount = 0;
  static DateTime? _lastTapTime;

  /// 读取本地保存的开关状态
  static Future<void> init() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      showDevTest.value = prefs.getBool(_keyShowDevTest) ?? false;
    } catch (e) {
      print('读取调试开关失败: $e');
    }
  }

  /// 记录一次图标点击：
  /// 连续点击 [needCount] 次则切换调试入口显示，返回是否触发了切换；
  /// 两次点击间隔超过 [resetDuration] 则重新计数
  static bool onLogoTap({
    int needCount = 5,
    Duration resetDuration = const Duration(seconds: 3),
  }) {
    final DateTime now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) > resetDuration) {
      _tapCount = 0;
    }
    _lastTapTime = now;
    _tapCount += 1;
    if (_tapCount < needCount) return false;
    _tapCount = 0;
    _lastTapTime = null;
    toggle();
    return true;
  }

  /// 切换「软件开发测试」入口显示并持久化
  static Future<void> toggle() async {
    showDevTest.value = !showDevTest.value;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyShowDevTest, showDevTest.value);
    } catch (e) {
      print('保存调试开关失败: $e');
    }
  }
}
