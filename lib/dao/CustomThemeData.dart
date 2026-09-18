/* FileName ThemeData
 *
 * @Author 20840
 * @Date 2024/10/1 16:58
 *
 * @Description TODO
 */
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/utils/ColorExtractor.dart';
import 'package:callo/utils/CourseWidgetUtil.dart';
import 'package:callo/utils/FileUtils.dart';

/// 主题配色预设（参考工墨的 8 套配色）
enum AppThemePreset {
  //海洋蓝放在最前，作为默认配色
  ocean('海洋蓝', [Color(0xFF1565C0), Color(0xFF42A5F5)]),
  sakura('粉白', [Color(0xFFEC5F92), Color(0xFFF9C5DA)]),
  green('墨绿', [Color(0xFF2E7D32), Color(0xFF4CAF50)]),
  mono('黑白', [Color(0xFF212121), Color(0xFF9E9E9E)]),
  tomato('番茄红', [Color(0xFFE53935), Color(0xFFFF8A65)]),
  starry('星夜', [Color(0xFF3B4A8F), Color(0xFF7C89CF), Color(0xFFF0B954)]),
  morandi('莫兰迪', [Color(0xFF8FA397), Color(0xFFC9B7A6), Color(0xFFA79BB0)]),
  grape('葡萄紫', [Color(0xFF7B1FA2), Color(0xFFBA68C8)]);

  final String label;
  final List<Color> swatches;
  const AppThemePreset(this.label, this.swatches);
}

class CustomThemeData {
  static final selectThemeUid = "".obs;
  static final nowThemeData ={}.obs;

  /// 当前配色预设（默认海洋蓝）
  static final preset = AppThemePreset.ocean.obs;

  /// 自动取色模式：从课表壁纸提取主题色（Material You 风格）
  static final isAutoColorMode = false.obs;

  /// 自动取色得到的种子色（未取到时为 null → 用默认种子色）
  static Color? _autoSeed;

  /// 自动取色无结果时使用的默认种子（M3 基线紫）
  static const Color _defaultAutoSeed = Color(0xFF6750A4);

  /// 当前应使用的色板：
  /// 自动取色模式 → 提取到的种子（没有则默认种子）；否则用所选预设
  static ColorScheme currentSchemeFor() {
    final Brightness brightness =
        _themeDark ? Brightness.dark : Brightness.light;
    if (isAutoColorMode.value) {
      return ColorScheme.fromSeed(
        seedColor: _autoSeed ?? _defaultAutoSeed,
        brightness: brightness,
      );
    }
    return schemeFor(preset.value, brightness);
  }

  /// 取色防抖：设置背景时会连续改多个开关，避免并发多次取色互相覆盖
  static Timer? _autoColorDebounce;

  /// 取色请求版本号：过期请求的结果直接丢弃
  static int _autoColorToken = 0;

  /// 延迟合并一次取色请求（背景设置变化时调用）
  static void scheduleAutoColorRefresh() {
    _autoColorDebounce?.cancel();
    _autoColorDebounce = Timer(const Duration(milliseconds: 400), () {
      refreshAutoColor();
    });
  }

  /// 从课表背景图重新提取主题色并应用
  static Future<void> refreshAutoColor({bool force = false}) async {
    if (!isAutoColorMode.value && !force) return;
    final int token = ++_autoColorToken;
    try {
      final Uint8List? bytes = await ColorExtractor.backgroundBytes();
      //已经有更新的取色请求（背景刚被改成别的图），丢弃过期结果
      if (token != _autoColorToken) return;
      if (bytes == null) return;
      final Color? seed = await ColorExtractor.extractSeed(bytes);
      if (token != _autoColorToken) return;
      if (seed == null) return;
      if (_autoSeed == seed) return; //颜色没变就不刷新
      _autoSeed = seed;
      if (isAutoColorMode.value) applyPreset();
    } catch (e) {
      print('自动取色失败: $e');
    }
  }

  /// 当前 M3 色板（由「配色预设 + 主题明暗」生成）
  static final currentScheme =
      ColorScheme.fromSeed(seedColor: AppThemePreset.ocean.swatches.first).obs;

  /// 当前主题明暗（唯一依据：主题 JSON，避免各处推导不一致导致反色）
  static bool _themeDark = false;
  static bool get isDarkTheme => _themeDark;

  /// 原始主题 JSON（未做 M3 映射），切换配色预设时用它重新生成
  static Map<String, dynamic>? _rawThemeJson;

  /// 卡片底色（工墨风格：亮色白卡片；暗色为每套预设单独调校的深色）
  static Color get cardColor {
    final bool dark = isDarkTheme;
    if (!dark) return Colors.white;
    switch (preset.value) {
      case AppThemePreset.sakura:
        return const Color(0xFF32262C);
      case AppThemePreset.green:
        return const Color(0xFF171B17);
      case AppThemePreset.mono:
        return const Color(0xFF1A1A1A);
      case AppThemePreset.tomato:
        return const Color(0xFF1E1514);
      case AppThemePreset.ocean:
        return const Color(0xFF14181D);
      case AppThemePreset.starry:
        return const Color(0xFF161826);
      case AppThemePreset.morandi:
        return const Color(0xFF1A1917);
      case AppThemePreset.grape:
        return const Color(0xFF171319);
    }
  }

  /// 页面底色（与工墨一致：每套预设单独的浅/深底色）
  static Color get pageColor {
    final bool dark = isDarkTheme;
    switch (preset.value) {
      case AppThemePreset.sakura:
        return dark ? const Color(0xFF251B21) : const Color(0xFFFFF2F7);
      case AppThemePreset.green:
        return dark ? const Color(0xFF0E110E) : const Color(0xFFF5F6F3);
      case AppThemePreset.mono:
        return dark ? const Color(0xFF0F0F0F) : const Color(0xFFF7F7F7);
      case AppThemePreset.tomato:
        return dark ? const Color(0xFF150F0E) : const Color(0xFFFAF5F4);
      case AppThemePreset.ocean:
        return dark ? const Color(0xFF0D1114) : const Color(0xFFF4F6F8);
      case AppThemePreset.starry:
        return dark ? const Color(0xFF0F1020) : const Color(0xFFF5F5F9);
      case AppThemePreset.morandi:
        return dark ? const Color(0xFF121110) : const Color(0xFFF6F5F2);
      case AppThemePreset.grape:
        return dark ? const Color(0xFF100D12) : const Color(0xFFF8F5F9);
    }
  }

  /// 生成配色（移植工墨：多数预设单色种子；starry/morandi 三色种子；
  /// sakura 浅色额外覆写，避免 fromSeed 生成的粉色偏暗沉）
  static ColorScheme schemeFor(AppThemePreset presetValue, Brightness brightness) {
    switch (presetValue) {
      case AppThemePreset.sakura:
        final ColorScheme base = ColorScheme.fromSeed(
          seedColor: const Color(0xFFF06292),
          brightness: brightness,
        );
        if (brightness == Brightness.dark) return base;
        return base.copyWith(
          primary: const Color(0xFFEC5F92),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFFFFD9E7),
          onPrimaryContainer: const Color(0xFF701A45),
          secondary: const Color(0xFFF28BB4),
          onSecondary: Colors.white,
          secondaryContainer: const Color(0xFFFDE4EF),
          onSecondaryContainer: const Color(0xFF5D2A40),
          tertiary: const Color(0xFFF6A589),
          tertiaryContainer: const Color(0xFFFFE0D4),
          onTertiaryContainer: const Color(0xFF5C2E1D),
          surface: const Color(0xFFFFF4F8),
        );
      case AppThemePreset.green:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: brightness,
        );
      case AppThemePreset.tomato:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFFE53935),
          brightness: brightness,
        );
      case AppThemePreset.mono:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF757575),
          brightness: brightness,
        );
      case AppThemePreset.ocean:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: brightness,
        );
      case AppThemePreset.starry:
        return _triColorScheme(
          const Color(0xFF3B4A8F),
          const Color(0xFF7C89CF),
          const Color(0xFFD99A2B),
          brightness,
        );
      case AppThemePreset.morandi:
        return _triColorScheme(
          const Color(0xFF8FA397),
          const Color(0xFFC9B7A6),
          const Color(0xFFA79BB0),
          brightness,
        );
      case AppThemePreset.grape:
        return ColorScheme.fromSeed(
          seedColor: const Color(0xFF7B1FA2),
          brightness: brightness,
        );
    }
  }

  /// 三色主题（工墨）：主/次/第三色分别作为 primary/secondary/tertiary 的种子
  static ColorScheme _triColorScheme(
    Color primarySeed,
    Color secondarySeed,
    Color tertiarySeed,
    Brightness brightness,
  ) {
    final ColorScheme base =
        ColorScheme.fromSeed(seedColor: primarySeed, brightness: brightness);
    final ColorScheme sec =
        ColorScheme.fromSeed(seedColor: secondarySeed, brightness: brightness);
    final ColorScheme ter =
        ColorScheme.fromSeed(seedColor: tertiarySeed, brightness: brightness);
    return base.copyWith(
      secondary: sec.secondary,
      onSecondary: sec.onSecondary,
      secondaryContainer: sec.secondaryContainer,
      onSecondaryContainer: sec.onSecondaryContainer,
      tertiary: ter.tertiary,
      onTertiary: ter.onTertiary,
      tertiaryContainer: ter.tertiaryContainer,
      onTertiaryContainer: ter.onTertiaryContainer,
    );
  }

  /// 应用当前配色（切换预设/自动取色/明暗后重新生成色板并刷新旧页面配色）
  static void applyPreset() {
    final ColorScheme scheme = currentSchemeFor();
    currentScheme.value = scheme;
    final Map<String, dynamic>? raw = _rawThemeJson;
    if (raw != null) {
      final Map<String, dynamic> mapped = _materialYouTheme(raw, scheme);
      nowThemeData.value = mapped;
      nowThemeData.refresh();
    }
    //配色变了，桌面课表小组件的配色也同步刷新
    CourseWidgetUtil.updateCourseWidget();
  }

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
    //由主题 JSON 决定明暗，并用「配色预设 + 明暗」生成 M3 色板（单一数据源）
    if (themeJson is Map<String, dynamic>) {
      _themeDark = _isDarkJson(themeJson);
      _rawThemeJson = themeJson;
      final ColorScheme scheme = currentSchemeFor();
      currentScheme.value = scheme;
      //把主题颜色统一映射为 M3 色板，旧页面无需改代码即可跟随配色
      themeJson = _materialYouTheme(themeJson, scheme);
    }
    final bool changed = _loadedThemeUid != uid;
    _loadedThemeUid = uid;
    CustomThemeData.nowThemeData.value = themeJson;
    CustomThemeData.nowThemeData.refresh();
    //说明：不再调用 Get.forceAppUpdate()（release 下是空操作且可能卡住流程）。
    //界面刷新由两层订阅保证：
    //1) main.dart 根节点 Obx —— 重建 ThemeData；
    //2) AppPages 里每个路由页面外层的 ThemeRebuild —— 重建页面并重新取色。
    //标记（保留变量，便于调试观察主题是否切换）
    assert(() {
      debugPrint('主题已切换: uid=$uid, dark=$_themeDark, changed=$changed');
      return true;
    }());
    //主题变化后同步刷新桌面课表小组件配色
    CourseWidgetUtil.updateCourseWidget();
  }

  //==================== Material You 主题色映射 ====================

  /// 取出主题 JSON 的明暗（用于生成色板）
  static bool _isDarkJson(Map<dynamic, dynamic> json) {
    final dynamic main = json['main_view'];
    if (main is Map) {
      final dynamic nav = main['bottomNavigate'];
      final dynamic bg = main['backgroundColor'] ??
          (nav is Map ? nav['backgroundColor'] : null);
      final Color? color = _rgbaColor(bg);
      if (color != null) return color.computeLuminance() < 0.45;
    }
    for (final dynamic page in json.values) {
      final Color? color =
          _rgbaColor(page is Map ? page['backgroundColor'] : null);
      if (color != null) return color.computeLuminance() < 0.45;
    }
    return false;
  }

  static Color? _rgbaColor(dynamic rgba) {
    if (rgba is List && rgba.length >= 4) {
      try {
        return Color.fromARGB(rgba[0] as int, rgba[1] as int, rgba[2] as int,
            rgba[3] as int);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  static List<int> _rgba(Color color) {
    final int value = color.toARGB32();
    return [
      (value >> 24) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 8) & 0xFF,
      value & 0xFF,
    ];
  }

  /// 单键映射：页面通用颜色键 → M3 语义色
  static Color? _mapKey(ColorScheme scheme, String key) {
    switch (key) {
      case 'backgroundColor':
        return scheme.surface;
      case 'textColor':
        return scheme.onSurface;
      case 'hintTextColor':
        return scheme.onSurfaceVariant;
      case 'nonNowWeekColor':
        return scheme.onSurfaceVariant;
      case 'foregroundColor':
        return scheme.surfaceContainerHighest;
      case 'defaultIconColor':
        return scheme.onSurfaceVariant;
      case 'shadowColor':
        return scheme.shadow;
      case 'nowWeekColor':
        return scheme.primary;
      case 'synIconColor':
        return scheme.primary;
      case 'leftTopShowColor':
        return scheme.surfaceContainerHigh;
      case 'courseLineColor':
        return scheme.outlineVariant;
      case 'selectColor':
      case 'selectScheduleColor':
        return scheme.primary;
      case 'nonSelectColor':
        return scheme.onSurfaceVariant;
      case 'nonSelectScheduleColor':
        return scheme.surfaceContainerHighest;
      default:
        return null;
    }
  }

  /// 课程格子配色（今天 / 非今天）
  static Map<String, dynamic> _courseItemColors(
      Map<dynamic, dynamic> source, ColorScheme scheme,
      {required bool today}) {
    final Map<String, dynamic> result = {};
    source.forEach((key, value) {
      final String name = '$key';
      Color? mapped;
      switch (name) {
        case 'backgroundColor':
        case 'weekBackgroundColor':
          mapped = today
              ? scheme.primaryContainer
              : scheme.surfaceContainerHigh;
          break;
        case 'borderColor':
        case 'weekBorderColor':
          mapped = today ? scheme.primary : scheme.outlineVariant;
          break;
      }
      result[name] = (mapped != null && value is List && value.length >= 4)
          ? _rgba(mapped)
          : value;
    });
    return result;
  }

  /// 递归转换主题 JSON：颜色值替换为 M3 色板，其它字段原样保留
  static Map<String, dynamic> _materialYouTheme(
      Map<String, dynamic> json, ColorScheme scheme) {
    Map<String, dynamic> convert(Map<dynamic, dynamic> source) {
      final Map<String, dynamic> result = {};
      source.forEach((key, value) {
        final String name = '$key';
        if (value is Map) {
          if (name == 'todayCourseItemColor') {
            result[name] = _courseItemColors(value, scheme, today: true);
          } else if (name == 'nonTodayCourseItemColor') {
            result[name] = _courseItemColors(value, scheme, today: false);
          } else {
            result[name] = convert(value);
          }
          return;
        }
        final Color? mapped = _mapKey(scheme, name);
        result[name] =
            (mapped != null && value is List && value.length >= 4)
                ? _rgba(mapped)
                : value;
      });
      return result;
    }

    return convert(json);
  }
}
