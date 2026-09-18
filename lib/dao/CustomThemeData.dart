/* FileName ThemeData
 *
 * @Author 20840
 * @Date 2024/10/1 16:58
 *
 * @Description TODO
 */
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';
import 'package:callo/utils/FileUtils.dart';

class CustomThemeData {
  static final selectThemeUid = "".obs;
  static final nowThemeData ={}.obs;

  //是否跟随系统夜间模式
  static final isFollowSystemDarkMode = false.obs;

  ///系统深色 → 黑色主题，浅色 → 白色主题
  static String themeUidForBrightness(Brightness brightness) =>
      brightness == Brightness.dark ? 'default:blackTheme' : 'default:whiteTheme';

  ///按当前系统深浅色应用主题（仅在开启“跟随系统”时生效）
  static Future<void> applySystemTheme() async {
    if (!isFollowSystemDarkMode.value) return;
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    await loadTheme(themeUidForBrightness(brightness));
  }

  ///监听系统深浅色切换（App 启动时调用一次）
  static void startSystemBrightnessListener() {
    WidgetsBinding.instance.platformDispatcher.onPlatformBrightnessChanged =
        () {
      applySystemTheme();
    };
  }

  //记录当前已加载的主题，避免重复强制刷新
  static String? _loadedThemeUid;

  static loadTheme(String themeUid) async {
    String themeType = themeUid.split(":")[0];
    String uid = themeUid.split(":")[1];
    switch(themeType){
      case "default": {
        await loadLocalTheme(uid);

      }
      break;
      case "network": {

      }
      break;
      default:
        break;
    }
  }
  static loadLocalTheme(String uid) async {
    var themeJson = jsonDecode(
        await FileUtils.loadJsonFromAssets('assets/theme/${uid}.json'));
    final bool changed = _loadedThemeUid != uid;
    _loadedThemeUid = uid;
    CustomThemeData.nowThemeData.value = themeJson;
    CustomThemeData.nowThemeData.refresh();
    //主题变化后强制刷新整个应用，避免需要切换页面才生效
    if (changed && Get.key.currentState != null) {
      await Get.forceAppUpdate();
    }
    //主题变化后同步刷新桌面课表小组件配色
    CourseWidgetUtil.updateCourseWidget();
  }
}
