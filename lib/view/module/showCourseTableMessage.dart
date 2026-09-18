import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import 'package:callo/utils/GlassUI.dart';

/// 课表课程详情弹层：毛玻璃 + 渐变风格
class showCourseTableMessage {
  dynamic _context;

  showCourseTableMessage(context) {
    _context = context;
  }

  Future show(courseJSON, DateTime dateTime /*授课日期*/) async {
    return showModalBottomSheet(
        context: _context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (builder) {
          return _showCourseTableMessageChild(
              courseJson: courseJSON, dateTime: dateTime);
        });
  }
}

class _showCourseTableMessageChild extends StatefulWidget {
  var courseJson;
  DateTime dateTime;
  _showCourseTableMessageChild(
      {Key? key, required this.courseJson, required this.dateTime})
      : super(key: key);
  @override
  State<_showCourseTableMessageChild> createState() =>
      _showCourseTableMessageChildState();
}

class _showCourseTableMessageChildState
    extends State<_showCourseTableMessageChild> {
  static const String _page = 'main_course_view';
  int _nowIndex = 1;
  int _sumIndex = 0;
  List<Widget> list = [];
  var courseJSON;
  DateTime dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    courseJSON = widget.courseJson;
    dateTime = widget.dateTime;
    _sumIndex = courseJSON.length;
    for (int i = 0; i < courseJSON.length; ++i) {
      final item = courseJSON[i];
      list.add(ListView(
        padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
        children: [
          _infoRow('课程', '${item['courseName']}'),
          _infoRow('授课地点', '${item['courseClassRoom']}'),
          _infoRow('授课日期时间',
              '${dateTime.month}月${dateTime.day}日   ${item['courseTime']}'),
          _infoRow('授课老师', '${item['courseTeacher']}'),
        ],
      ));
    }
  }

  /// 信息行：左标签 + 右值
  Widget _infoRow(String label, String value) {
    final Color text = GlassTheme.textColor(_page);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 78,
            child: Text(label,
                style: TextStyle(
                    fontSize: 13, color: text.withValues(alpha: .55))),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    final Color base = GlassTheme.pageBackground(_page);
    final Color accent = GlassTheme.accentColor(_page);
    final bool dark = GlassTheme.isDark(_page);
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: Container(
          height: 320,
          decoration: BoxDecoration(
            color: GlassTheme.scheme.surfaceContainerLow,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              //拖拽提示
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: text.withValues(alpha: .18),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: GlassSectionTitle(
                          page: _page, title: '课程详情'),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$_nowIndex/$_sumIndex',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: accent),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Expanded(
                  child: PageView(
                children: list,
                onPageChanged: (int index) {
                  _nowIndex = index + 1;
                  setState(() {});
                },
                reverse: false,
              )),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
                child: GradientButton(
                  text: '确定',
                  page: _page,
                  height: 46,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
