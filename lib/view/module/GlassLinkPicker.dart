import 'package:flutter/material.dart';

import 'package:callo/utils/GlassUI.dart';

/// 毛玻璃多级联动选择器（替代 flutter_pickers 的 showMultiLinkPicker）
///
/// [data] 支持嵌套 Map（层级用 keys），最后一层可以是 Map 或 List；
/// [selectData] 传入当前已选项作为初始定位；[columnNum] 为列数。
/// 返回选中路径（长度 = columnNum），取消返回 null。
Future<List<String>?> showGlassLinkPicker(
  BuildContext context, {
  required dynamic data,
  List<String>? selectData,
  required int columnNum,
  String title = '请选择',
  String page = 'main_view',
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .35),
    builder: (ctx) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: GlassCard(
          page: page,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: GlassLinkPicker(
            data: data,
            selectData: selectData,
            columnNum: columnNum,
            title: title,
            page: page,
          ),
        ),
      ),
    ),
  );
}

class GlassLinkPicker extends StatefulWidget {
  const GlassLinkPicker({
    super.key,
    required this.data,
    this.selectData,
    required this.columnNum,
    this.title = '请选择',
    this.page = 'main_view',
  });

  final dynamic data;
  final List<String>? selectData;
  final int columnNum;
  final String title;
  final String page;

  @override
  State<GlassLinkPicker> createState() => _GlassLinkPickerState();
}

class _GlassLinkPickerState extends State<GlassLinkPicker> {
  late List<List<String>> _columns;
  late List<String> _selected;

  int get _columnCount => widget.columnNum < 1 ? 1 : widget.columnNum;

  @override
  void initState() {
    super.initState();
    _selected = List<String>.filled(_columnCount, '');
    _columns = List.generate(_columnCount, (_) => <String>[]);
    final List<String> initial =
        (widget.selectData ?? const []).map((e) => '$e').toList();
    for (int i = 0; i < _columnCount; i++) {
      _columns[i] = _optionsAt(i);
      if (i < initial.length && _columns[i].contains(initial[i])) {
        _selected[i] = initial[i];
      } else if (_columns[i].isNotEmpty) {
        _selected[i] = _columns[i].first;
      }
    }
  }

  /// 取第 level 列的可选项（基于前面已选路径）
  List<String> _optionsAt(int level) {
    dynamic node = widget.data;
    for (int i = 0; i < level; i++) {
      if (node is Map && node.containsKey(_selected[i])) {
        node = node[_selected[i]];
      } else {
        return <String>[];
      }
    }
    if (node is Map) return node.keys.map((e) => '$e').toList();
    if (node is List) return node.map((e) => '$e').toList();
    return <String>[];
  }

  void _select(int level, String value) {
    setState(() {
      _selected[level] = value;
      for (int i = level + 1; i < _columnCount; i++) {
        _columns[i] = _optionsAt(i);
        _selected[i] = _columns[i].isNotEmpty ? _columns[i].first : '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(widget.page);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GlassSectionTitle(
                  page: widget.page, title: widget.title),
            ),
            SizedBox(
              width: 72,
              child: GradientButton(
                text: '确定',
                page: widget.page,
                height: 36,
                onPressed: () =>
                    Navigator.pop(context, List<String>.from(_selected)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: Row(
            children: [
              for (int i = 0; i < _columnCount; i++) ...[
                if (i > 0) const SizedBox(width: 8),
                Expanded(child: _column(i, text)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _column(int level, Color text) {
    final Color accent = GlassTheme.accentColor(widget.page);
    final List<String> options = _columns[level];
    if (options.isEmpty) {
      return Center(
        child: Text('暂无数据',
            style:
                TextStyle(fontSize: 12, color: text.withValues(alpha: .45))),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: options.length,
      itemBuilder: (context, index) {
        final String option = options[index];
        final bool selected = _selected[level] == option;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _select(level, option),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected
                    ? accent.withValues(alpha: .16)
                    : text.withValues(alpha: .04),
                border: Border.all(
                  color: selected
                      ? accent.withValues(alpha: .60)
                      : text.withValues(alpha: .10),
                  width: selected ? 1.2 : 1,
                ),
              ),
              child: Text(
                option,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12.5,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? accent : text),
              ),
            ),
          ),
        );
      },
    );
  }
}
