import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/edusys/entity/TrainPlanInForm.dart';

import 'logic.dart';

/// 培养计划（学期课程列表）：毛玻璃 + 渐变风格
class TrainPlanSemesterViewPage extends StatelessWidget {
  TrainPlanSemesterViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TrainPlanSemesterViewLogic>();
  final state = Get.find<TrainPlanSemesterViewLogic>().state;

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${state.semester.value}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: text)),
              Text(
                '${state.translate.value}',
                style: TextStyle(
                    fontSize: 11, color: text.withValues(alpha: .55)),
              ),
            ],
          ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 120),
          itemCount: state.dataList.value.length,
          itemBuilder: (BuildContext context, int index) {
            return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 350),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: showchildElement(state.dataList.value[index]),
                  ),
                ));
          },
        ),
      ),
    );
  }

  /// 单个课程卡片
  Widget showchildElement(TrainPlanInForm trainPlanInForm) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //序号圆
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, GlassTheme.lighten(accent, .35)],
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: accent.withValues(alpha: .35),
                        blurRadius: 8,
                        offset: const Offset(0, 3))
                  ],
                ),
                child: Center(
                  child: Text(
                    '${trainPlanInForm.number}',
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${trainPlanInForm.courseName}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: text.withValues(alpha: .08), height: 1),
          const SizedBox(height: 6),
          _row2('编号', '${trainPlanInForm.code}', '学分',
              '${trainPlanInForm.credit}'),
          _row2('开课单位', '${trainPlanInForm.unit}', '学时',
              '${trainPlanInForm.creditHour}'),
          _row2('考核模式', '${trainPlanInForm.evaMode}', '课程属性',
              '${trainPlanInForm.property}'),
          _row2('是否考核', '${trainPlanInForm.isExam}', '', ''),
        ],
      ),
    );
  }

  /// 两列键值行
  Widget _row2(String l1, String v1, String l2, String v2) {
    final Color text = GlassTheme.textColor(_page);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _kv(l1, v1, text)),
          if (l2.isNotEmpty) Expanded(child: _kv(l2, v2, text)),
        ],
      ),
    );
  }

  Widget _kv(String label, String value, Color text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style:
                TextStyle(fontSize: 12, color: text.withValues(alpha: .5))),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 12.5, fontWeight: FontWeight.w600, color: text),
          ),
        ),
      ],
    );
  }
}
