/* FileName ThemeData
 *
 * @Author 20840
 * @Date 2024/10/1 16:58
 *
 * @Description TODO
 */
import 'dart:convert';

import 'package:get/get.dart';
import 'package:nnlg/utils/FileUtils.dart';

class CustomThemeData {
  static final selectThemeUid = "".obs;
  static final nowThemeData ={}.obs;

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
    CustomThemeData.nowThemeData.value = themeJson;
    CustomThemeData.nowThemeData.refresh();
  }
}
