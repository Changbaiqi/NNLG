/* FileName GlassUI
 *
 * @Description 全局 UI 规范：Material You（Material 3 动态取色）风格通用组件
 *
 * 使用约定：
 * 1. 页面背景用 [GlassBackground]（M3 surface 底色）
 * 2. 卡片/面板统一用 [GlassCard]，段落标题用 [GlassSectionTitle]
 * 3. 主按钮用 [GradientButton]（M3 Filled 按钮样式），统计数字用 [GlassStat]
 * 4. 颜色全部来自当前主题的 ColorScheme（支持 Android 12+ 动态取色）
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/CustomThemeData.dart';

/// 统一设计参数
class GlassTokens {
  static const double radius = 16;
  static const double radiusSmall = 12;
  static const double pagePad = 16;
  static const double blur = 0;
  static const Color accent = Color(0xFF6750A4);
  static const Color text = Color(0xFF1C1B20);
  static const Color subText = Color(0xFF8A8A93);
}

/// 主题色取值：统一走 Material 3 的 ColorScheme（支持动态取色）
class GlassTheme {
  /// 当前 Material 主题色板（唯一数据源，读取即订阅主题变化）
  static ColorScheme get scheme => CustomThemeData.currentScheme.value;

  /// 页面背景色（工墨风格：每套预设单独的浅/深底色）
  static Color pageBackground(String page,
      [Color fallback = const Color(0xFFF6F6FA)]) {
    return CustomThemeData.pageColor;
  }

  /// 兼容旧代码的取色（按主题键映射到 M3 色板）
  static Color color(String page, String key,
      [Color fallback = Colors.white]) {
    final ColorScheme scheme = GlassTheme.scheme;
    switch (key) {
      case 'backgroundColor':
        return scheme.surface;
      case 'textColor':
        return scheme.onSurface;
      case 'hintTextColor':
        return scheme.onSurfaceVariant;
      case 'foregroundColor':
        return scheme.surfaceContainerHighest;
      case 'defaultIconColor':
        return scheme.onSurfaceVariant;
      case 'shadowColor':
        return scheme.shadow;
      case 'courseLineColor':
        return scheme.outlineVariant;
      default:
        return fallback;
    }
  }

  /// 兼容旧代码的二级取色（如 bottomNavigate.selectColor）
  static Color nested(String page, String group, String key,
      [Color fallback = Colors.white]) {
    final ColorScheme scheme = GlassTheme.scheme;
    switch (key) {
      case 'backgroundColor':
        return scheme.surfaceContainer;
      case 'selectColor':
      case 'selectScheduleColor':
        return scheme.primary;
      case 'nonSelectColor':
        return scheme.onSurfaceVariant;
      case 'nonSelectScheduleColor':
        return scheme.surfaceContainerHighest;
      case 'textColor':
        return scheme.onSurface;
      case 'shadowColor':
        return scheme.shadow;
      default:
        return fallback;
    }
  }

  /// 底部导航配置（兼容老代码的 main_view.bottomNavigate）
  static Color bottomNav(String key, [Color fallback = Colors.white]) {
    return nested('main_view', 'bottomNavigate', key, fallback);
  }

  static Color textColor(String page) => scheme.onSurface;

  static bool isDark(String page) => CustomThemeData.isDarkTheme;

  static Color accentColor(String page) => scheme.primary;

  /// 次要文字色
  static Color subTextColor(String page) => scheme.onSurfaceVariant;

  static Color border(String page) => scheme.outlineVariant;

  static Color surface(String page) => CustomThemeData.cardColor;

  static Color shadow(String page) =>
      scheme.shadow.withValues(alpha: scheme.brightness == Brightness.dark ? .30 : .10);

  /// 把主色提亮，用于渐变/高亮（保留给非 M3 场景使用）
  static Color lighten(Color c, [double amount = .28]) =>
      Color.alphaBlend(Colors.white.withValues(alpha: amount), c);

  static Color darken(Color c, [double amount = .35]) =>
      Color.alphaBlend(Colors.black.withValues(alpha: amount), c);

  /// 两色对比度（WCAG）
  static double contrastRatio(Color a, Color b) {
    final double l1 = a.computeLuminance();
    final double l2 = b.computeLuminance();
    final double hi = l1 > l2 ? l1 : l2;
    final double lo = l1 > l2 ? l2 : l1;
    return (hi + .05) / (lo + .05);
  }

  /// 按表面色推导可读前景色（永远黑或白）
  static Color onSurface(Color surface, [double alpha = 1]) =>
      (surface.computeLuminance() > .55 ? Colors.black : Colors.white)
          .withValues(alpha: alpha);

  /// 保证主色在表面上足够可读，不足时向黑白方向校正
  static Color readableAccent(Color accent, Color surface) {
    if (contrastRatio(accent, surface) >= 2.6) return accent;
    return surface.computeLuminance() > .5
        ? darken(accent, .38)
        : lighten(accent, .38);
  }

  /// 毛玻璃表面色（M3 下返回容器的实际合成色）
  static Color glassSurfaceOn(String page, Color base) => scheme.surfaceContainerHigh;

  /// 毛玻璃表面用的底色（M3 下用 surfaceContainer）
  static Color glassTint(String page) => scheme.surfaceContainer;

  /// 毛玻璃表面透明度（M3 下不透明）
  static double glassAlpha(String page) => 1;
}

/// 页面背景：M3 surface 底色
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.page, required this.child});

  final String page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //自订阅主题：即使外层页面没有重建，也能实时换色
    return Obx(() => ColoredBox(
          color: CustomThemeData.pageColor,
          child: child,
        ));
  }
}

/// Material 3 卡片
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.page,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.radius = GlassTokens.radius,
    this.blur = GlassTokens.blur,
    this.gradient,
    this.elevated = true,
  });

  final String page;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final GestureTapDownCallback? onTapDown;
  final GestureTapUpCallback? onTapUp;
  final GestureTapCancelCallback? onTapCancel;
  final double radius;
  final double blur;
  final Gradient? gradient;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    //自订阅主题：即使外层页面没有重建，也能实时换色
    return Obx(() {
      final ColorScheme scheme = GlassTheme.scheme;
      //工墨风格：卡片无阴影、用低对比描边 + 预设卡片底色（亮色为白卡片）
      Widget card = Container(
        decoration: BoxDecoration(
          color: gradient == null ? CustomThemeData.cardColor : null,
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: scheme.outlineVariant.withValues(alpha: .35),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            onTapDown: onTapDown,
            onTapUp: onTapUp,
            onTapCancel: onTapCancel,
            child: Padding(padding: padding, child: child),
          ),
        ),
      );
      if (margin != null) card = Padding(padding: margin!, child: card);
      return card;
    });
  }
}

/// 主题变化时重建子页面：
/// release 下 Get.forceAppUpdate() 是空操作、路由页面不会自己重建，
/// 这里订阅主题状态并重新构造页面实例，让页面 build 重新取色（同时保留 State）
class ThemeRebuild extends StatelessWidget {
  const ThemeRebuild({super.key, required this.builder});

  final Widget Function() builder;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      CustomThemeData.nowThemeData.value;
      CustomThemeData.currentScheme.value;
      CustomThemeData.selectThemeUid.value;
      CustomThemeData.isFollowSystemDarkMode.value;
      return builder();
    });
  }
}

/// 过渡动画期间的模糊开关（M3 下无模糊，保留用于兼容旧调用）
final ValueNotifier<bool> glassBlurSuppress = ValueNotifier<bool>(false);

class GlassBlurGate extends StatefulWidget {
  const GlassBlurGate({super.key, required this.builder});

  final Widget Function(bool blurred) builder;

  @override
  State<GlassBlurGate> createState() => _GlassBlurGateState();
}

class _GlassBlurGateState extends State<GlassBlurGate> {
  @override
  Widget build(BuildContext context) => widget.builder(true);
}

/// 主按钮：Material 3 Filled 按钮样式
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.page = 'main_view',
    this.height = 48,
    this.colors,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final String page;
  final double height;

  /// 自定义底色（不传时用主题主色）
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    //自订阅主题
    return Obx(() {
    final bool enabled = onPressed != null;
    final ColorScheme scheme = GlassTheme.scheme;
    final Color bg =
        (colors != null && colors!.isNotEmpty) ? colors!.first : scheme.primary;
    final Color fg = GlassTheme.contrastRatio(bg, Colors.white) >= 2.2
        ? Colors.white
        : GlassTheme.onSurface(bg);
    return Opacity(
      opacity: enabled ? 1 : .5,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
          child: InkWell(
            borderRadius: BorderRadius.circular(height / 2),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: fg, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: TextStyle(
                      color: fg,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    });
  }
}

/// 段落标题：Material 3 标题样式
class GlassSectionTitle extends StatelessWidget {
  const GlassSectionTitle({
    super.key,
    required this.page,
    required this.title,
    this.trailing,
  });

  final String page;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    //自订阅主题
    return Obx(() {
      final ColorScheme scheme = GlassTheme.scheme;
      return Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      );
    });
  }
}

/// 统计数字（主色文字）
class GlassStat extends StatelessWidget {
  const GlassStat({
    super.key,
    required this.page,
    required this.value,
    required this.label,
    this.icon,
    this.valueWidget,
  });

  final String page;
  final String value;
  final String label;
  final IconData? icon;

  /// 自定义数值控件（例如 AnimatedFlipCounter），传入后忽略 [value]
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    //自订阅主题
    return Obx(() {
      final ColorScheme scheme = GlassTheme.scheme;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: scheme.primary),
                const SizedBox(width: 4),
              ],
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: scheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          valueWidget ??
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
        ],
      );
    });
  }
}

/// 下拉选择器：Material 3 样式
class GlassDropdown<T> extends StatelessWidget {
  const GlassDropdown({
    super.key,
    required this.page,
    required this.items,
    required this.value,
    required this.onChanged,
    this.title = '请选择',
    this.maxTextWidth = 132,
  });

  final String page;
  final List<T> items;
  final T? value;
  final ValueChanged<T> onChanged;
  final String title;
  final double maxTextWidth;

  @override
  Widget build(BuildContext context) {
    //自订阅主题
    return Obx(() {
    final ColorScheme scheme = GlassTheme.scheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: items.isEmpty ? null : () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: scheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxTextWidth),
              child: Text(
                '${value ?? ''}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: scheme.onSurface),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more_rounded,
                size: 18, color: scheme.onSurfaceVariant),
          ],
        ),
      ),
    );
    });
  }

  Future<void> _openPicker(BuildContext context) async {
    final T? selected = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .32),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: GlassCard(
              page: page,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassSectionTitle(page: page, title: title),
                  const SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 320),
                    child: SingleChildScrollView(
                      child: Column(
                        children:
                            items.map((e) => _buildItem(ctx, e)).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (selected != null) onChanged(selected);
  }

  Widget _buildItem(BuildContext ctx, T item) {
    final ColorScheme scheme = GlassTheme.scheme;
    final bool selected = item == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.pop(ctx, item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? scheme.secondaryContainer : Colors.transparent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '$item',
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected
                          ? scheme.onSecondaryContainer
                          : scheme.onSurface),
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded,
                    size: 18, color: scheme.onSecondaryContainer),
            ],
          ),
        ),
      ),
    );
  }
}

/// 功能入口（图标 + 文案）：M3 tonal 色块
class GlassIconTile extends StatelessWidget {
  const GlassIconTile({
    super.key,
    required this.page,
    required this.child,
    this.onTap,
    this.radius = GlassTokens.radiusSmall,
  });

  final String page;
  final Widget child;
  final VoidCallback? onTap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    //自订阅主题
    return Obx(() {
      final ColorScheme scheme = GlassTheme.scheme;
      return Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          decoration: BoxDecoration(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              child: child,
            ),
          ),
        ),
      );
    });
  }
}
