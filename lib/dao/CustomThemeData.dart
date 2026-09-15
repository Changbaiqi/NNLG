/* FileName ThemeData
 *
 * @Author 20840
 * @Date 2024/10/1 16:58
 *
 * @Description TODO
 */
import 'dart:convert';

import 'package:get/get.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';
import 'package:callo/utils/FileUtils.dart';

class CustomThemeData {
  static final selectThemeUid = "".obs;
  static final nowThemeData ={}.obs;

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
