/* FileName CourseWidgetUtil
 *
 * @Description TODO 桌面课表小组件数据构建与刷新
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:path_provider/path_provider.dart';

import 'package:callo/dao/CourseData.dart';
import 'package:callo/dao/CustomThemeData.dart';

class CourseWidgetUtil {
  //Android 小组件 Provider 完整类名
  static const String androidProvider =
      'com.cbq.callocollege.CourseWidgetProvider';

  static const String _dataKey = 'course_widget_data';

  //与原生通信（进程内刷新小组件，避免部分系统限制广播）
  static const MethodChannel _refreshChannel =
      MethodChannel('com.cbq.callocollege/shortcut');

  //随机二次元背景缓存标记：同一会话内最多每小时重新下载一次
  static DateTime? _randomBgDownloadAt;
  static String? _cachedBgSignature;
  static String? _cachedBgPath;

  /// 构建并刷新桌面小组件数据（整学期课表，原生按当天日期取今日课程）
  static Future<void> updateCourseWidget() async {
    try {
      final dynamic courseJson = CourseData.weekCourseJson.value;
      if (courseJson is! Map) return;
      final dynamic courses = courseJson['courses'];
      if (courses is! List || courses.isEmpty) return;

      final List<String> timeList =
          CourseData.courseTime.value.map((e) => '$e').toList();

      final List<List<List<Map<String, dynamic>>>> weeks = [];
      for (final week in courses) {
        weeks.add(List.generate(
            7, (day) => _buildDayRows(week, day, timeList)));
      }

      final dynamic theme = CustomThemeData.nowThemeData.value['main_course_view'];
      final Color themeBg =
          _themeColor(theme is Map ? theme['backgroundColor'] : null) ??
              Colors.white;
      final bool isDark = themeBg.computeLuminance() < 0.45;
      //小组件实际底色（与 widget_card_bg_dark/light 对应），用于推导副文字
      final Color bgColor = isDark ? const Color(0xFF24242A) : Colors.white;
      final double bgLum = bgColor.computeLuminance();

      Color textColor =
          _themeColor(theme is Map ? theme['textColor'] : null) ??
              (isDark ? const Color(0xFFEDEDED) : const Color(0xFF222222));
      //主题文字色与卡片底色过于接近时（如黑色主题），换成高对比默认色
      if ((textColor.computeLuminance() - bgLum).abs() < 0.35) {
        textColor = isDark ? const Color(0xFFEDEDED) : const Color(0xFF222222);
      }

      final dynamic todayItem =
          theme is Map ? theme['todayCourseItemColor'] : null;
      Color accentColor =
          _themeColor(todayItem is Map ? todayItem['borderColor'] : null) ??
              _themeColor(theme is Map ? theme['nowWeekColor'] : null) ??
              const Color(0xFF7C4DFF);
      //该颜色在主题中是描边/背景用途（黑色主题里接近纯黑），
      //用作小组件文字时按卡片底色提亮/压暗，保证可读
      if (isDark && accentColor.computeLuminance() < 0.35) {
        accentColor = Color.lerp(accentColor, Colors.white, .55)!;
      } else if (!isDark && accentColor.computeLuminance() > 0.75) {
        accentColor = Color.lerp(accentColor, Colors.black, .35)!;
      }

      //副文字用不透明混色，避免深色卡片上叠加透明度过暗
      Color subColor = Color.lerp(textColor, bgColor, isDark ? .35 : .4)!;

      //统一做对比度兜底：任何主题/配色/自动取色下，文字都保证看得清
      textColor = ensureReadable(textColor, bgColor, 4.5);
      subColor = ensureReadable(subColor, bgColor, 3.0);
      accentColor = ensureReadable(accentColor, bgColor, 3.0);

      //自定义背景图（下载/复用本地文件），失败时回退到上次缓存
      final String bgPath = await _resolveWidgetBackgroundPath();
      final double bgAlpha = CourseData.courseWidgetBackgroundOpacity.value;

      //数据版本号：数据或配色发生变化时让桌面重建列表适配器，保证一定刷新
      final int dataVersion =
          '${CourseData.schoolOpenTime.value}|${CourseData.ansWeek.value}|${jsonEncode(weeks)}'
                  '|${textColor.toARGB32()}|${subColor.toARGB32()}|${accentColor.toARGB32()}'
                  '|$bgPath|$bgAlpha|pv2'
              .hashCode;

      final Map<String, dynamic> payload = {
        'v': dataVersion,
        'open': CourseData.schoolOpenTime.value,
        'ans': CourseData.ansWeek.value,
        'dark': isDark,
        'text': textColor.toARGB32(),
        'sub': subColor.toARGB32(),
        'accent': accentColor.toARGB32(),
        'bgPath': bgPath,
        'bgAlpha': bgAlpha,
        //午休分割线开关（与课表设置同步）
        'noon': CourseData.isNoonLineSwitch.value,
        'weeks': weeks,
      };

      await HomeWidget.saveWidgetData<String>(_dataKey, jsonEncode(payload));
      try {
        await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
      } catch (e) {
        print('课表小组件广播刷新失败: $e');
      }
      // 部分系统（如 MIUI）对广播刷新不敏感，再走一次原生进程内刷新
      try {
        await _refreshChannel.invokeMethod('refreshCourseWidget');
      } catch (_) {
        // 非 Android 或通道不可用时忽略
      }
    } catch (e) {
      print('课表小组件刷新失败: $e');
    }
  }

  /// 解析小组件自定义背景图的本地路径：
  /// 随机二次元 / 自定义URL（下载到本地） / 本地图片，未开启时返回空串
  static Future<String> _resolveWidgetBackgroundPath() async {
    if (!CourseData.isCourseWidgetCustomBackground.value) return '';
    try {
      final Directory dir = await getApplicationDocumentsDirectory();
      if (CourseData.isCourseWidgetRandomQuadraticBackground.value) {
        final File file = File('${dir.path}/courseWidgetBg_random.jpg');
        final bool needRefresh = _randomBgDownloadAt == null ||
            DateTime.now().difference(_randomBgDownloadAt!) >
                const Duration(hours: 1) ||
            !file.existsSync();
        if (!needRefresh) return file.path;
        await Dio().download(
          'https://img.xjh.me/random_img.php?type=bg&ctype=nature&return=302',
          file.path,
          options: Options(
              responseType: ResponseType.bytes, followRedirects: true),
        );
        _randomBgDownloadAt = DateTime.now();
        _cachedBgPath = file.path;
        return file.path;
      }
      if (CourseData.isCourseWidgetUrlBackground.value) {
        final String url =
            CourseData.courseWidgetBackgroundInputUrl.value.trim();
        if (url.isEmpty) return '';
        final String signature = 'url:$url';
        if (_cachedBgSignature == signature &&
            _cachedBgPath != null &&
            File(_cachedBgPath!).existsSync()) {
          return _cachedBgPath!;
        }
        final File file = File('${dir.path}/courseWidgetBg_url.jpg');
        await Dio().download(url, file.path,
            options: Options(followRedirects: true));
        _cachedBgSignature = signature;
        _cachedBgPath = file.path;
        return file.path;
      }
      if (CourseData.isCourseWidgetLocalBackground.value) {
        final String path = CourseData.courseWidgetBackgroundFilePath.value;
        if (path.isEmpty || !File(path).existsSync()) return '';
        return path;
      }
    } catch (e) {
      print('课表小组件背景处理失败: $e');
      if (_cachedBgPath != null && File(_cachedBgPath!).existsSync()) {
        return _cachedBgPath!;
      }
    }
    return '';
  }

  /// 清除桌面小组件数据（退出登录时调用）
  static Future<void> clearCourseWidget() async {
    try {
      await HomeWidget.saveWidgetData<String>(_dataKey, null);
      await HomeWidget.updateWidget(qualifiedAndroidName: androidProvider);
    } catch (e) {
      print('清除课表小组件数据失败: $e');
    }
  }

  /// 请求把课表小组件添加到桌面（Android 8.0+）
  static Future<bool> requestAddWidget() async {
    try {
      final bool supported =
          await HomeWidget.isRequestPinWidgetSupported() ?? false;
      if (!supported) return false;
      await HomeWidget.requestPinWidget(
        qualifiedAndroidName: androidProvider,
        name: 'CourseWidgetProvider',
      );
      return true;
    } catch (e) {
      print('添加课表小组件失败: $e');
      return false;
    }
  }

  /// 合并一个自然日内连续节次的相同课程，生成小组件渲染行
  static List<Map<String, dynamic>> _buildDayRows(
      dynamic week, int day, List<String> timeList) {
    final List<Map<String, dynamic>> rows = [];
    if (week is! List || week.isEmpty) return rows;

    final Map<String, Map<String, dynamic>> open = {};
    for (int period = 0; period < week.length; period++) {
      final dynamic rowCells = week[period];
      final List cells = (rowCells is List &&
              day < rowCells.length &&
              rowCells[day] is List)
          ? rowCells[day] as List
          : const [];
      final Set<String> keys = {};
      for (final course in cells) {
        if (course is! Map) continue;
        final String name = '${course['courseName'] ?? ''}';
        if (name.isEmpty) continue;
        final String room = '${course['courseClassRoom'] ?? ''}';
        final String key = '$name|$room';
        keys.add(key);
        final existing = open[key];
        if (existing == null) {
          open[key] = {
            'n': name,
            'r': room,
            'ps': period + 1,
            'pe': period + 1,
            's': _timeOfDay(timeList, period, true),
            'e': _timeOfDay(timeList, period, false),
            'c': _courseColor(name),
          };
        } else {
          existing['pe'] = period + 1;
          existing['e'] = _timeOfDay(timeList, period, false);
        }
      }
      open.removeWhere((key, row) {
        if (!keys.contains(key)) {
          rows.add(row);
          return true;
        }
        return false;
      });
    }
    for (final row in open.values) {
      rows.add(row);
    }

    rows.sort((a, b) => '${a['s']}'.compareTo('${b['s']}'));
    bool noonMarked = false;
    for (final row in rows) {
      final int ps = row.remove('ps') as int;
      final int pe = row.remove('pe') as int;
      row['p'] = ps == pe ? '第$ps节' : '第$ps-$pe节';
      //与课表一致：第 5 节起为下午，第一节下午课打上"午休"分割线标记
      //注意：不能用 'n'，它是课程名的键
      if (!noonMarked && ps >= 5) {
        row['nr'] = 1;
        noonMarked = true;
      }
    }
    return rows;
  }

  /// 取某节课的开始/结束时间（HH:mm）
  static String _timeOfDay(List<String> timeList, int period, bool start) {
    if (period < 0 || period >= timeList.length) return '';
    final List<String> parts = timeList[period].split('-');
    if (parts.isEmpty) return '';
    return (start ? parts.first : parts.last).trim();
  }

  /// 根据课程名生成稳定的柔和配色，用于小组件左侧色条
  static int _courseColor(String name) {
    final int hash = name.hashCode.abs();
    return HSVColor.fromAHSV(1.0, (hash % 360).toDouble(), 0.55, 0.82)
        .toColor()
        .toARGB32();
  }

  /// 保证 [color] 在 [bg] 上的对比度不低于 [minRatio]（WCAG）。
  /// 不足时朝与背景相反的方向逐级调整，保证任何主题下都看得清
  static Color ensureReadable(Color color, Color bg, double minRatio) {
    if (_contrastRatio(color, bg) >= minRatio) return color;
    final bool bgDark = bg.computeLuminance() < .5;
    Color result = color;
    for (int i = 0; i < 10; i++) {
      result = bgDark
          ? Color.lerp(result, Colors.white, .22)!
          : Color.lerp(result, Colors.black, .22)!;
      if (_contrastRatio(result, bg) >= minRatio) break;
    }
    return result;
  }

  /// WCAG 对比度
  static double _contrastRatio(Color a, Color b) {
    final double l1 = a.computeLuminance();
    final double l2 = b.computeLuminance();
    final double hi = l1 > l2 ? l1 : l2;
    final double lo = l1 > l2 ? l2 : l1;
    return (hi + .05) / (lo + .05);
  }

  /// [r,g,b,a] 转 Color
  static Color? _themeColor(dynamic colorList) {
    if (colorList is List && colorList.length >= 4) {
      try {
        return Color.fromARGB(
          (colorList[0] as num).toInt(),
          (colorList[1] as num).toInt(),
          (colorList[2] as num).toInt(),
          (colorList[3] as num).toInt(),
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
