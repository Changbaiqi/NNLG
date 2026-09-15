import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 在线评教（批次列表）：毛玻璃 + 渐变风格
class TeachingEvaViewPage extends StatelessWidget {
  TeachingEvaViewPage({Key? key}) : super(key: key);

  final logic = Get.find<TeachingEvaViewLogic>();
  final state = Get.find<TeachingEvaViewLogic>().state;

  static const String _page = 'teaching_eva_view';

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
          title: Text('在线评教',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: text)),
        ),
        body: Obx(() {
          switch (state.showState.value) {
            case 0:
              return Center(
                  child: Lottie.asset('assets/images/loading.json',
                      height: 200, width: 200));
            case 1:
              return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 120),
                  itemCount: state.searList.value.length,
                  itemBuilder: (cont, index) =>
                      AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: showchildElement(
                                state.searList.value[index]),
                          ),
                        ),
                      ));
            default:
              return Center(
                  child: Text('错误', style: TextStyle(color: text)));
          }
        }),
      ),
    );
  }

  /// 单个批次卡片
  showchildElement(json) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      padding: const EdgeInsets.fromLTRB(14, 12, 12, 10),
      onTap: () {
        Get.toNamed(Routes.TeachingEvaDetails,
            arguments: {'url': json['evalUrl']});
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //批次数
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
                    '${json["number"]}',
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
                  '${json["schoolYear"]}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: text),
                ),
              ),
              Icon(Icons.chevron_right_rounded,
                  color: text.withValues(alpha: .30)),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: text.withValues(alpha: .08), height: 1),
          const SizedBox(height: 6),
          _row2('评价分类', '${json["evalClass"]}', '评价批次',
              '${json["evalBatch"]}'),
          _row2('开始时间', '${json["evalStartTime"]}', '结束时间',
              '${json["evalEndTime"]}'),
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
          Expanded(child: _kv(l2, v2, text)),
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
