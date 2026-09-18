import 'package:flutter/material.dart';

import 'package:callo/utils/GlassUI.dart';

/// 同步刷新按钮：
/// - 同步中：图标持续旋转 + 文案切换为「同步中...」，按钮禁止重复点击
/// - 完成后：短暂显示 ✓ 成功 / ⚠ 失败（颜色随主题），900ms 后恢复
/// - 图标与文案用淡入 + 缩放切换，观感与整体 Material You 风格一致
class SyncRefreshButton extends StatefulWidget {
  const SyncRefreshButton({
    super.key,
    required this.page,
    required this.onSync,
    this.label = '刷新数据',
    this.height = 42,
  });

  final String page;

  /// 返回 true=成功, false=失败, null=条件不满足（不显示成功/失败反馈）
  final Future<bool?> Function() onSync;
  final String label;
  final double height;

  @override
  State<SyncRefreshButton> createState() => _SyncRefreshButtonState();
}

class _SyncRefreshButtonState extends State<SyncRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spin = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 900));

  bool _syncing = false;
  bool? _result; // null=空闲/进行中, true=成功, false=失败

  @override
  void dispose() {
    _spin.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (_syncing) return;
    setState(() {
      _syncing = true;
      _result = null;
    });
    _spin.repeat();
    bool? ok;
    try {
      ok = await widget.onSync();
    } catch (_) {
      ok = false;
    }
    if (!mounted) return;
    _spin.stop();
    if (ok == null) {
      //条件不满足（例如未绑定宿舍）：直接回到初始状态
      setState(() => _syncing = false);
      return;
    }
    setState(() {
      _syncing = false;
      _result = ok;
    });
    //成功/失败反馈短暂显示后恢复
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _result = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme cs = GlassTheme.scheme;
    final Color bg = _result == false ? cs.error : cs.primary;
    final Color fg = _result == false ? cs.onError : cs.onPrimary;
    final Widget icon = _syncing
        ? RotationTransition(
            turns: _spin,
            child: Icon(Icons.refresh_rounded, color: fg, size: 18),
          )
        : Icon(
            _result == null
                ? Icons.refresh_rounded
                : (_result! ? Icons.check_rounded : Icons.error_outline_rounded),
            color: fg,
            size: 18,
          );
    final String text = _syncing
        ? '同步中...'
        : (_result == null ? widget.label : (_result! ? '同步成功' : '同步失败'));
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      height: widget.height,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.height / 2),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.height / 2),
          onTap: _handleTap,
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: ScaleTransition(scale: anim, child: child),
              ),
              child: Row(
                key: ValueKey('${_syncing}_${_result}_$text'),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(
                        color: fg,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
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
