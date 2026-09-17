import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:callo/dao/CourseData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 培养计划（学期列表）：毛玻璃 + 渐变风格
class TrainPlanViewPage extends StatelessWidget {
  TrainPlanViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TrainPlanViewLogic>();
  final state = Get.find<TrainPlanViewLogic>().state;

  static const String _page = 'train_plan_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: text,
          iconTheme: IconThemeData(color: text),
          title: Text('培养计划',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: text)),
        ),
        body: Obx(() {
          final List<String> keys = state.mapList.value.keys.toList();
          if (keys.isEmpty) {
            return Center(
                child: Lottie.asset('assets/images/loading.json',
                    height: 200, width: 200));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 120),
            itemCount: keys.length,
            itemBuilder: (BuildContext context, int index) {
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 350),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    //注意：这里不能用递增计数器取 translate，
                    //重建（返回页面）时下标会越界导致白屏
                    child: listChild(keys[index], _translateOf(index)),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  /// 学期序号对应的“大X上/下学期”名称，越界时回退为“第N学期”
  String _translateOf(int index) {
    final List<String> translateList = state.translate.value;
    if (index >= 0 && index < translateList.length) {
      return translateList[index];
    }
    return '第${index + 1}学期';
  }

  //学期列表选项
  Widget listChild(String semester, String translate) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    final bool isCurrent = CourseData.nowCourseList.value == '$semester';
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
      onTap: () {
        Get.toNamed(Routes.TrainPlanSemester, arguments: {
          'semester': semester,
          'translate': translate,
          'dataList': state.mapList.value['${semester}']
        });
      },
      child: Row(
        children: [
          //左侧渐变竖条
          Container(
            width: 5,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [accent, GlassTheme.lighten(accent, .35)],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$semester',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: text)),
                const SizedBox(height: 3),
                Text(
                  '人话：$translate',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 12, color: text.withValues(alpha: .55)),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (isCurrent)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accent.withValues(alpha: .30)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.my_location_rounded, size: 13, color: accent),
                  const SizedBox(width: 4),
                  Text('当前课表',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: accent)),
                ],
              ),
            )
          else
            Icon(Icons.chevron_right_rounded,
                color: text.withValues(alpha: .30)),
        ],
      ),
    );
  }
}
