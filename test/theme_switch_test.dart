import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/GlassUI.dart';

/// 模拟真实页面：在 build 中捕获主题颜色（这是原先切换主题不刷新的关键场景）
class _FakePage extends StatelessWidget {
  const _FakePage({super.key});

  static Color? lastColor;

  @override
  Widget build(BuildContext context) {
    //与真实页面一致：build 时取色并捕获
    lastColor = GlassTheme.scheme.surface;
    return Container(color: lastColor, width: 20, height: 20);
  }
}

/// 主题切换回归测试：
/// 1) 数据层：白/黑主题的明暗判定与 M3 色板必须正确（防止再次反色）；
/// 2) 界面层：主题切换后，Obx 包裹的界面要能实时刷新（release 下也必须生效）
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Color? pageBackgroundColor() {
    final dynamic page = CustomThemeData.nowThemeData.value['main_course_view'];
    final dynamic rgba = page is Map ? page['backgroundColor'] : null;
    if (rgba is! List || rgba.length < 4) return null;
    return Color.fromARGB(
        rgba[0] as int, rgba[1] as int, rgba[2] as int, rgba[3] as int);
  }

  test('数据层：切换白/黑主题时明暗与色板正确', () async {
    await CustomThemeData.loadTheme('default:whiteTheme');
    expect(CustomThemeData.isDarkTheme, isFalse);
    expect(CustomThemeData.currentScheme.value.brightness, Brightness.light);
    expect(GlassTheme.scheme.brightness, Brightness.light);
    expect(GlassTheme.isDark('main_view'), isFalse);
    expect(pageBackgroundColor()!.computeLuminance(), greaterThan(.5),
        reason: '白色主题的页面底色应该是浅色');

    await CustomThemeData.loadTheme('default:blackTheme');
    expect(CustomThemeData.isDarkTheme, isTrue);
    expect(CustomThemeData.currentScheme.value.brightness, Brightness.dark);
    expect(GlassTheme.scheme.brightness, Brightness.dark);
    expect(GlassTheme.isDark('main_view'), isTrue);
    expect(pageBackgroundColor()!.computeLuminance(), lessThan(.5),
        reason: '黑色主题的页面底色应该是深色');
  });

  test('配色预设：切换后色板/卡片/页面底色同步变化', () async {
    await CustomThemeData.loadTheme('default:whiteTheme');

    CustomThemeData.preset.value = AppThemePreset.ocean;
    CustomThemeData.applyPreset();
    final Color oceanPrimary = CustomThemeData.currentScheme.value.primary;
    expect(pageBackgroundColor()!.computeLuminance(), greaterThan(.5),
        reason: '白色主题下切换预设后页面底色仍是浅色');
    expect(CustomThemeData.cardColor, Colors.white,
        reason: '亮色下卡片应为白色（工墨风格）');

    CustomThemeData.preset.value = AppThemePreset.grape;
    CustomThemeData.applyPreset();
    expect(CustomThemeData.currentScheme.value.primary,
        isNot(equals(oceanPrimary)),
        reason: '不同预设的主色应不同');

    await CustomThemeData.loadTheme('default:blackTheme');
    expect(CustomThemeData.cardColor, isNot(equals(Colors.black)),
        reason: '暗色卡片不应是纯黑（工墨逐预设调校）');
    expect(CustomThemeData.pageColor.computeLuminance(), lessThan(.2));

    //恢复默认预设，避免影响其它用例
    CustomThemeData.preset.value = AppThemePreset.green;
    CustomThemeData.applyPreset();
  });

  testWidgets('路由页面：主题切换后页面被重建并重新取色', (tester) async {
    await tester.runAsync(() => CustomThemeData.loadTheme('default:whiteTheme'));
    await tester.pumpWidget(MaterialApp(
      home: ThemeRebuild(builder: () => _FakePage(key: const ValueKey('page'))),
    ));
    //页面 build 里捕获的颜色：白色主题下应为浅色
    expect(_FakePage.lastColor!.computeLuminance(), greaterThan(.5));

    await tester.runAsync(() => CustomThemeData.loadTheme('default:blackTheme'));
    await tester.pump();

    //页面没有重新导航，但应该因为主题变化被重建、颜色重建为深色
    expect(_FakePage.lastColor!.computeLuminance(), lessThan(.5),
        reason: '主题切换后页面（含 build 中捕获的颜色）必须刷新');
  });

  testWidgets('界面层：主题切换后界面实时刷新', (tester) async {
    await tester.runAsync(() => CustomThemeData.loadTheme('default:whiteTheme'));
    final Key key = UniqueKey();
    await tester.pumpWidget(Obx(() => MaterialApp(
          theme: ThemeData.from(
              colorScheme: CustomThemeData.currentScheme.value,
              useMaterial3: true),
          home: Container(key: key, color: GlassTheme.scheme.surface),
        )));
    final Color lightColor = tester.widget<Container>(find.byKey(key)).color!;
    expect(lightColor.computeLuminance(), greaterThan(.5));

    await tester.runAsync(() => CustomThemeData.loadTheme('default:blackTheme'));
    await tester.pump();

    final Color darkColor = tester.widget<Container>(find.byKey(key)).color!;
    expect(darkColor.computeLuminance(), lessThan(.5),
        reason: '切换黑色主题后界面颜色应实时变为深色');
  });
}
