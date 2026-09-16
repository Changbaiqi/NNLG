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
import 'package:callo/utils/CusBehavior.dart';
import 'package:callo/utils/GlassUI.dart';

import 'dao/ClassScheduleDao.dart';

/// 当前主题的页面底色，用于消除页面切换时的白闪
/// 注意：黑色主题的 main_view 没有 backgroundColor，需要回退到导航背景色
Color _themeBackground() => GlassTheme.pageBackground('main_view');

/// 应用主题：转场动画会用 colorScheme.surface 打底，必须跟随主题背景色，
/// 否则推送页面时会出现白色闪烁
ThemeData _appTheme() {
  final Color bg = _themeBackground();
  // 点击水波纹跟随主题：深色主题用柔和白光、浅色主题用柔和暗光，
  // 默认的 InkSparkle 在深色页面上会闪出亮白色星芒，与主题很不搭
  final Color onBg = GlassTheme.textColor('main_view');
  final ThemeData base = ThemeData.fallback();
  return base.copyWith(
    scaffoldBackgroundColor: bg,
    colorScheme: base.colorScheme.copyWith(surface: bg),
    // 页面滚动到 AppBar 下方时不要突然出现着色/阴影（透明导航栏上会呈现为阴影跳变）
    appBarTheme: const AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
    ),
    splashFactory: InkRipple.splashFactory,
    splashColor: onBg.withValues(alpha: .08),
    highlightColor: onBg.withValues(alpha: .04),
    hoverColor: onBg.withValues(alpha: .04),
    focusColor: onBg.withValues(alpha: .06),
    // 按钮的按压态默认取 colorScheme.primary（未换肤时的紫白色），一并跟随主题
    elevatedButtonTheme:
        ElevatedButtonThemeData(style: _pressOverlayStyle(onBg)),
    textButtonTheme: TextButtonThemeData(style: _pressOverlayStyle(onBg)),
    outlinedButtonTheme:
        OutlinedButtonThemeData(style: _pressOverlayStyle(onBg)),
    iconButtonTheme: IconButtonThemeData(style: _pressOverlayStyle(onBg)),
  );
}

/// 按钮按压/悬停态颜色（跟随主题文字色，避免默认紫白色高亮）
ButtonStyle _pressOverlayStyle(Color onBg) {
  return ButtonStyle(
    overlayColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return onBg.withValues(alpha: .12);
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return onBg.withValues(alpha: .06);
      }
      return null;
    }),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return ScreenUtilInit(
      designSize: const Size(2080, 2340),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        theme: _appTheme(),
        home: ColoredBox(
          color: _themeBackground(),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: GetMaterialApp(
                initialRoute: Routes.Start,
                getPages: AppPages.pages,
                theme: _appTheme(),
                // 转场/页面切换时窗口底色跟随主题，避免白色闪烁
                color: _themeBackground(),
                builder: (context, child) => ScrollConfiguration(
                      behavior: const CusBehavior(),
                      child: ColoredBox(
                        color: _themeBackground(),
                        child: child ?? const SizedBox.shrink(),
                      ),
                    )),
          ),
        ),
      ),
    );
  }
}
