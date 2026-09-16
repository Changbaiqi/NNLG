/* FileName GlassUI
 *
 * @Description TODO 全局 UI 规范：毛玻璃 + 渐变风格通用组件
 *
 * 使用约定：
 * 1. 页面背景用 [GlassBackground]（作为毛玻璃的底，需要它才能看到模糊效果）
 * 2. 卡片/面板统一用 [GlassCard]，段落标题用 [GlassSectionTitle]
 * 3. 主按钮用 [GradientButton]，统计数字用 [GlassStat]，功能入口用 [GlassIconTile]
 * 4. 所有组件颜色优先取页面主题 JSON，缺失时用兜底色，保证各主题下都可用
 */
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:callo/dao/CustomThemeData.dart';

/// 统一设计参数
class GlassTokens {
  static const double radius = 18;
  static const double radiusSmall = 12;
  static const double pagePad = 16;
  static const double blur = 18;
  static const Color accent = Color(0xFF7C4DFF);
  static const Color text = Color(0xFF1C1B20);
  static const Color subText = Color(0xFF8A8A93);
}

/// 从页面主题 JSON 安全取色
class GlassTheme {
  static dynamic _page(String page) {
    final dynamic data = CustomThemeData.nowThemeData.value;
    if (data is Map) return data[page];
    return null;
  }

  static Color _color(dynamic rgba, Color fallback) {
    if (rgba is List && rgba.length >= 4) {
      try {
        return Color.fromARGB(rgba[0] as int, rgba[1] as int, rgba[2] as int,
            rgba[3] as int);
      } catch (_) {
        return fallback;
      }
    }
    return fallback;
  }

  /// [rgba] 合法时返回颜色，否则 null
  static Color? _read(dynamic rgba) {
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

  /// 页面背景色（带回退链）：页面 backgroundColor → 底部导航 backgroundColor →
  /// 任意页面的 backgroundColor → 兜底色。
  /// 例如黑色主题的 main_view 只配置了 bottomNavigate，需要回退到它的背景色
  static Color pageBackground(String page,
      [Color fallback = const Color(0xFFF6F6FA)]) {
    final dynamic p = _page(page);
    if (p is Map) {
      final Color? direct = _read(p['backgroundColor']);
      if (direct != null) return direct;
      final dynamic nav = p['bottomNavigate'];
      if (nav is Map) {
        final Color? navColor = _read(nav['backgroundColor']);
        if (navColor != null) return navColor;
      }
    }
    final dynamic data = CustomThemeData.nowThemeData.value;
    if (data is Map) {
      final Color? navColor = _read((data['main_view'] is Map &&
              (data['main_view'] as Map)['bottomNavigate'] is Map)
          ? ((data['main_view'] as Map)['bottomNavigate'] as Map)['backgroundColor']
          : null);
      if (navColor != null) return navColor;
      for (final dynamic other in data.values) {
        final Color? c = _read(other is Map ? other['backgroundColor'] : null);
        if (c != null) return c;
      }
    }
    return fallback;
  }

  /// 读取页面主题的一级颜色，如 backgroundColor / textColor
  static Color color(String page, String key,
      [Color fallback = Colors.white]) {
    final dynamic p = _page(page);
    if (p is Map && p[key] != null) return _color(p[key], fallback);
    return fallback;
  }

  /// 读取页面主题的二级颜色，如 bottomNavigate.selectColor
  static Color nested(String page, String group, String key,
      [Color fallback = Colors.white]) {
    final dynamic p = _page(page);
    if (p is Map) {
      final dynamic g = p[group];
      if (g is Map && g[key] != null) return _color(g[key], fallback);
    }
    return fallback;
  }

  /// 底部导航配置（兼容老代码的 main_view.bottomNavigate）
  static Color bottomNav(String key, [Color fallback = Colors.white]) {
    return nested('main_view', 'bottomNavigate', key, fallback);
  }

  static Color textColor(String page) {
    final dynamic p = _page(page);
    if (p is Map) {
      final Color? direct = _read(p['textColor']);
      if (direct != null) return direct;
    }
    // 页面未配置文字色时（例如黑色主题下没有 login_view 小节），
    // 按页面背景亮度自动取黑/白，避免深色背景上出现深色字
    return onSurface(pageBackground(page));
  }

  static Color accentColor(String page) {
    final Color a = color(page, 'synIconColor', Colors.transparent);
    if (a.a > 0) return a;
    final Color navSelect =
        bottomNav('selectColor', Colors.transparent);
    if (navSelect.a > 0) return navSelect;
    return GlassTokens.accent;
  }

  static bool isDark(String page) =>
      pageBackground(page).computeLuminance() < 0.45;

  /// 毛玻璃卡片的填充色
  static Color surface(String page) => isDark(page)
      ? Colors.white.withValues(alpha: .07)
      : Colors.white.withValues(alpha: .60);

  /// 毛玻璃卡片的描边色
  static Color border(String page) => isDark(page)
      ? Colors.white.withValues(alpha: .14)
      : Colors.white.withValues(alpha: .85);

  static Color shadow(String page) => Colors.black
      .withValues(alpha: isDark(page) ? .32 : .08);

  /// 把主色提亮，用于渐变按钮/图标
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

  /// 毛玻璃导航/面板的实际表面色（合成后），用于推导前景色
  static Color glassSurfaceOn(String page, Color base) {
    return Color.alphaBlend(
        glassTint(page).withValues(alpha: glassAlpha(page)), base);
  }

  /// 毛玻璃表面用的底色（优先取主题的导航背景色，保证与主题一致）
  static Color glassTint(String page) {
    final bool dark = isDark(page);
    return bottomNav('backgroundColor',
        dark ? const Color(0xFF141218) : Colors.white);
  }

  /// 毛玻璃表面透明度：保留可透视/模糊感
  static double glassAlpha(String page) => isDark(page) ? .58 : .72;
}

/// 页面渐变背景：所有毛玻璃效果的底
class GlassBackground extends StatelessWidget {
  const GlassBackground({super.key, required this.page, required this.child});

  final String page;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool dark = GlassTheme.isDark(page);
    final Color base = GlassTheme.pageBackground(page);
    final Color accent = GlassTheme.accentColor(page);
    final Color top =
        Color.alphaBlend(accent.withValues(alpha: dark ? .24 : .16), base);
    final Color bottom =
        Color.alphaBlend(accent.withValues(alpha: dark ? .05 : .03), base);
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [top, base, bottom],
          stops: const [0, .5, 1],
        ),
      ),
      child: child,
    );
  }
}

/// 毛玻璃卡片
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
    final Color borderColor = GlassTheme.border(page);
    Widget card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: gradient == null ? GlassTheme.surface(page) : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor, width: 1),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: onTap,
              onTapDown: onTapDown,
              onTapUp: onTapUp,
              onTapCancel: onTapCancel,
              child: Padding(padding: padding, child: child),
            ),
          ),
        ),
      ),
    );
    if (elevated) {
      card = DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: GlassTheme.shadow(page),
              blurRadius: 22,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: card,
      );
    }
    if (margin != null) card = Padding(padding: margin!, child: card);
    return card;
  }
}

/// 渐变主按钮
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

  /// 自定义渐变（不传时用页面主题强调色）
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final Color accent = GlassTheme.accentColor(page);
    final List<Color> gradientColors =
        colors ?? [accent, GlassTheme.lighten(accent)];
    return Opacity(
      opacity: enabled ? 1 : .55,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(height / 2.6),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: .38),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(height / 2.6),
            splashColor: Colors.white.withValues(alpha: .18),
            highlightColor: Colors.white.withValues(alpha: .08),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 段落标题：渐变小竖条 + 标题
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
    final Color accent = GlassTheme.accentColor(page);
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [accent, GlassTheme.lighten(accent)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: GlassTheme.textColor(page),
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

/// 统计数字（渐变文字）
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
    final Color accent = GlassTheme.accentColor(page);
    final Color text = GlassTheme.textColor(page);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: accent),
              const SizedBox(width: 4),
            ],
            Text(label,
                style: TextStyle(
                    fontSize: 12, color: text.withValues(alpha: .62))),
          ],
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (Rect rect) => LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [accent, GlassTheme.lighten(accent, .45)],
          ).createShader(rect),
          child: valueWidget ??
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
        ),
      ],
    );
  }
}

/// 毛玻璃下拉选择器：胶囊按钮 + 毛玻璃选择弹层
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
    final Color text = GlassTheme.textColor(page);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: items.isEmpty ? null : () => _openPicker(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: GlassTheme.glassTint(page)
              .withValues(alpha: GlassTheme.glassAlpha(page)),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: GlassTheme.border(page), width: 1),
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
                    fontSize: 13, fontWeight: FontWeight.w600, color: text),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.expand_more_rounded,
                size: 18, color: text.withValues(alpha: .7)),
          ],
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final T? selected = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: .35),
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
    final Color text = GlassTheme.textColor(page);
    final Color accent = GlassTheme.accentColor(page);
    final bool selected = item == value;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.pop(ctx, item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: selected
                ? accent.withValues(alpha: .16)
                : text.withValues(alpha: .05),
            border: Border.all(
              color: selected
                  ? accent.withValues(alpha: .60)
                  : text.withValues(alpha: .12),
              width: selected ? 1.3 : 1,
            ),
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
                      color: selected ? accent : text),
                ),
              ),
              if (selected)
                Icon(Icons.check_rounded, size: 18, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

/// 功能入口（图标 + 文案，毛玻璃小块）
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
    final Color accent = GlassTheme.accentColor(page);
    // 这里刻意不使用 BackdropFilter：列表/网格中大量模糊会导致首帧闪烁
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        decoration: BoxDecoration(
          color: accent.withValues(alpha: GlassTheme.isDark(page) ? .10 : .07),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: accent.withValues(alpha: .18),
            width: 1,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
