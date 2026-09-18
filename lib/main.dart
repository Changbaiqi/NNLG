import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:callo/dao/ClassNewScheduleDao.dart';
import 'package:callo/dao/ClassScheduleDatabase.dart';
import 'package:callo/view/router/AppPages.dart';
import 'package:callo/view/router/Routes.dart';
import 'package:callo/view/module/showCourseWidgetDialog.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/CusBehavior.dart';

import 'dao/ClassScheduleDao.dart';

/// 应用主题：Material 3 + 8 套配色预设（参考工墨）
/// 色板来自唯一数据源 CustomThemeData.currentScheme（主题 JSON 决定明暗）
ThemeData _appTheme() {
  final ColorScheme scheme = CustomThemeData.currentScheme.value;
  final bool isDark = CustomThemeData.isDarkTheme;
  final Color cardColor = CustomThemeData.cardColor;
  final Color pageColor = CustomThemeData.pageColor;
  final Color onBg = scheme.onSurface;

  OutlineInputBorder border(Color color, [double width = 1]) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );

  final ThemeData base = ThemeData.from(colorScheme: scheme, useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: pageColor,
    colorScheme: scheme,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      foregroundColor: scheme.onSurface,
      titleTextStyle: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w600, color: scheme.onSurface),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cardColor,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .35)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outlineVariant.withValues(alpha: .4),
      thickness: .6,
      space: 1,
    ),
    listTileTheme: ListTileThemeData(
      iconColor: scheme.onSurfaceVariant,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? Colors.white.withValues(alpha: .04)
          : Colors.black.withValues(alpha: .025),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: border(scheme.outlineVariant.withValues(alpha: .5)),
      enabledBorder: border(scheme.outlineVariant.withValues(alpha: .5)),
      focusedBorder: border(scheme.primary, 1.5),
      hintStyle: TextStyle(color: scheme.onSurfaceVariant),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: cardColor,
      selectedColor: scheme.primaryContainer,
      labelStyle: TextStyle(fontSize: 12.5, color: scheme.onSurface),
      side: BorderSide(color: scheme.outlineVariant.withValues(alpha: .6)),
      shape: const StadiumBorder(),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        minimumSize: const Size(88, 46),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ).copyWith(overlayColor: _pressOverlay(onBg)),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: scheme.primary,
        minimumSize: const Size(88, 46),
        side: BorderSide(color: scheme.primary.withValues(alpha: .5)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ).copyWith(overlayColor: _pressOverlay(onBg)),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ).copyWith(overlayColor: _pressOverlay(onBg)),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(overlayColor: _pressOverlay(onBg)),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 3,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      shape: const CircleBorder(),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor:
          isDark ? const Color(0xFF2C322C) : const Color(0xFF252A25),
      contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: cardColor,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titleTextStyle: TextStyle(
          fontSize: 17, fontWeight: FontWeight.w600, color: scheme.onSurface),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected) ? Colors.white : null,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (states) => states.contains(WidgetState.selected)
            ? scheme.primary
            : scheme.surfaceContainerHighest,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
    ),
    splashFactory: InkRipple.splashFactory,
    splashColor: onBg.withValues(alpha: .08),
    highlightColor: onBg.withValues(alpha: .04),
    hoverColor: onBg.withValues(alpha: .04),
    focusColor: onBg.withValues(alpha: .06),
  );
}

/// 按钮按压/悬停态颜色（跟随主题文字色，避免默认紫白色高亮）
WidgetStateProperty<Color?> _pressOverlay(Color onBg) {
  return WidgetStateProperty.resolveWith((states) {
    if (states.contains(WidgetState.pressed)) {
      return onBg.withValues(alpha: .12);
    }
    if (states.contains(WidgetState.hovered) ||
        states.contains(WidgetState.focused)) {
      return onBg.withValues(alpha: .06);
    }
    return null;
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //监听系统深浅色切换（开启“跟随系统夜间模式”时自动换主题）
  CustomThemeData.startSystemBrightnessListener();

  //数据库迁移更新
  final database = await $FloorClassScheduleDatabase
      .databaseBuilder('app_database.db')
      .addMigrations([
    Migration(4, 6, (database) async {
      await database.update('ClassScheduleEntity', {'list': null});
    }),
    Migration(5, 6, (database) async {
      // await database.update('ClassScheduleEntity', {'list': null});
      await database
          .execute('''CREATE TABLE IF NOT EXISTS ClassNewScheduleEntity (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        studentId TEXT NOT NULL,
        semester TEXT,
        uid TEXT,
        dateTime DATETIME,
        md5 TEXT,
        json TEXT
    );''');
    })
  ]).build();
  // final database = await $FloorClassScheduleDatabase.databaseBuilder('app_database.db').build();
  final classScheduleDao = database.classScheduleDao;
  final classNewScheduleDao = database.classNewScheduleDao;

  GetIt getIt = GetIt.instance;
  getIt.registerSingleton<ClassScheduleDao>(classScheduleDao,
      signalsReady: true);
  getIt.registerSingleton<ClassNewScheduleDao>(classNewScheduleDao,
      signalsReady: true);

  //监听长按桌面图标「添加课表小组件」快捷方式
  initCourseWidgetShortcut();

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //订阅主题数据变化：Material You 的颜色都来自 ThemeData，
    //根节点不重建会导致切换主题后页面颜色不刷新
    return Obx(() {
      CustomThemeData.nowThemeData.value;
      CustomThemeData.currentScheme.value;
      CustomThemeData.selectThemeUid.value;
      CustomThemeData.isFollowSystemDarkMode.value;
      final ThemeData theme = _appTheme();
      final Color background = theme.colorScheme.surface;
      return ScreenUtilInit(
        designSize: const Size(2080, 2340),
        minTextAdapt: true,
        splitScreenMode: true,
        child: MaterialApp(
          theme: theme,
          home: ColoredBox(
            color: background,
            child: MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: GetMaterialApp(
                  initialRoute: Routes.Start,
                  getPages: AppPages.pages,
                  theme: theme,
                  // 转场/页面切换时窗口底色跟随主题，避免白色闪烁
                  color: background,
                  builder: (context, child) => ScrollConfiguration(
                        behavior: const CusBehavior(),
                        child: ColoredBox(
                          color: background,
                          child: child ?? const SizedBox.shrink(),
                        ),
                      )),
            ),
          ),
        ),
      );
    });
  }
}
