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
  static final nowThemeData = {
    "main_view": {
      "bottomNavigate": {
        "backgroundColor": [255, 20, 20, 20],
        "selectColor": [255, 96, 125, 139],
        "nonSelectColor": [255, 255, 255, 255],
        "textColor": [255, 160, 160, 160],
      }
    },
    "main_community_view": {
      "color": [255, 34, 35, 40],
      "forceColor": [255, 59, 59, 59],
      "textColor": [255, 160, 160, 160],
      "backgroundImage": "assets/images/backgroundTest.jpg"
    },
    "main_water_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "textColor": [255, 160, 160, 160]
    },
    "main_course_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "nowWeekColor": [255, 200, 200, 200],
      "nonNowWeekColor": [255, 252, 85, 49],
      "iconColor": [255, 200, 200, 200],
      "synIconColor": [255, 252, 85, 49],
      "courseLineColor": [255, 200, 200, 200]
    },
    "score_inquiry_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "nowWeekColor": [255, 200, 200, 200],
      "nonNowWeekColor": [255, 252, 85, 49],
      "iconColor": [255, 200, 200, 200],
      "synIconColor": [255, 252, 85, 49]
    },
    "train_plan_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "hintTextColor": [255, 126, 132, 163],
      "nowWeekColor": [255, 200, 200, 200],
      "nonNowWeekColor": [255, 252, 85, 49],
      "iconColor": [255, 200, 200, 200],
      "synIconColor": [255, 252, 85, 49]
    },
    "main_user_view": {
      "color": [255, 34, 35, 40],
      "forceColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160]
    },
    "chit_chat_view": {
      "backgroundColor": [255, 34, 35, 40],
      "forceColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160]
    },
    "exam_inquiry_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160]
    },
    "course_set_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "hintTextColor": [255, 126, 132, 163]
    },
    "nnlg_community_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "hintTextColor": [255, 126, 132, 163]
    },
    "about_me_view": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "defaultIconColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160]
    },
    "showUpdateDialog": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "selectColor": [255, 96, 125, 139],
      "nonSelectColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160],
      "hintTextColor": [255, 126, 132, 163]
    },
    "showBindPowerDialog": {
      "backgroundColor": [255, 34, 35, 40],
      "foregroundColor": [255, 59, 59, 59],
      "hintTextColor": [255, 126, 132, 163],
      "selectColor": [255, 96, 125, 139],
      "nonSelectColor": [255, 255, 255, 255],
      "textColor": [255, 160, 160, 160]
    }
  }.obs;

  static loadLocalTheme() async {
    var themeJson = jsonDecode(
        await FileUtils.loadJsonFromAssets('assets/theme/whiteTheme.json'));
    CustomThemeData.nowThemeData.value = themeJson;
  }
}
