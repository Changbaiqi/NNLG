import 'package:flutter/material.dart';
import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/GlassUI.dart';

/*
 * [author] 长白崎
 * [date] 2024/2/10 21:38
 * [description] TODO 本学期总周数选择
 */
class showCourseNumSheet {
  dynamic _context;

  showCourseNumSheet(context) {
    _context = context;
  }

  Future show() async {
    return showModalBottomSheet(
        context: _context,
        backgroundColor: Colors.transparent,
        barrierColor: Colors.black.withValues(alpha: .35),
        builder: (builder) {
          return GlassCard(
            page: 'course_set_view',
            padding: EdgeInsets.fromLTRB(16, 18, 16, 16),
            child: showCourseNumSheetMain(),
          );
        });
  }
}

class showCourseNumSheetMain extends StatefulWidget {
  const showCourseNumSheetMain({Key? key}) : super(key: key);

  @override
  State<showCourseNumSheetMain> createState() => _showCourseNumSheetMainState();
}

class _showCourseNumSheetMainState extends State<showCourseNumSheetMain> {
  int _index = 0;
  List<int> _courseList = [];

  List<Widget> updateCourseListWidget() {
    final Color textColor = GlassTheme.textColor('course_set_view');
    List<Widget> courseListWidget = [];
    _courseList.clear();
    for (int i = 17; i <= 30; ++i) {
      _courseList.add(i);
      Widget chooseWidget = Container(
        alignment: Alignment.center,
        child: Text(
          '$i',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      );
      courseListWidget.add(chooseWidget);
    }

    return courseListWidget;
  }

  FixedExtentScrollController _controller = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    final Color textColor = GlassTheme.textColor('course_set_view');
    return SizedBox(
      height: 330,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      GlassTheme.accentColor('course_set_view'),
                      GlassTheme.accentColor('course_set_view')
                          .withValues(alpha: .5),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '本学期总周数',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Text(
                '${_index + 17} 周',
                style: TextStyle(
                  fontSize: 13,
                  color: textColor.withValues(alpha: .6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListWheelScrollView(
              itemExtent: 46,
              useMagnifier: true,
              magnification: 1.35,
              controller: _controller,
              onSelectedItemChanged: (index) {
                setState(() {
                  _index = index;
                });
              },
              physics: const FixedExtentScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: updateCourseListWidget(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 46,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: textColor.withValues(alpha: .08),
                      foregroundColor: textColor.withValues(alpha: .8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(23)),
                    ),
                    child: const Text('取消', style: TextStyle(fontSize: 15)),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: GradientButton(
                  text: '确定',
                  page: 'course_set_view',
                  height: 46,
                  onPressed: () {
                    Navigator.pop(context, _index + 17);
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  initCourseNumChoose() {
    int target = CourseData.ansWeek.value - 17;
    target = target.clamp(0, _courseList.length - 1);
    _controller.animateToItem(target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutQuart);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initCourseNumChoose();
    });
  }
}
