import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 考试安排：毛玻璃 + 渐变风格
class ExamInquiryViewPage extends StatelessWidget {
  ExamInquiryViewPage({Key? key}) : super(key: key);

  final logic = Get.find<ExamInquiryViewLogic>();
  final state = Get.find<ExamInquiryViewLogic>().state;

  static const String _page = 'exam_inquiry_view';

  @override
  Widget build(BuildContext context) {
    var itemWidth = (MediaQuery.of(context).size.width - 42) / 2;
    var itemHeight = 215.0;
    var childAspectRatio = itemWidth / itemHeight;

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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('考试安排',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, color: text)),
              Obx(() => GlassDropdown<String>(
                    page: _page,
                    items: state.searList.value,
                    value: state.selectTime.value,
                    title: '选择学期',
                    onChanged: (value) {
                      state.selectTime.value = value;
                      logic.showScoreList(state.selectTime.value);
                    },
                  ))
            ],
          ),
        ),
        body: Obx(() {
          switch (state.showState.value) {
            case 0:
              return Center(
                  child: Lottie.asset('assets/images/loading.json',
                      height: 200, width: 200));
            case 1:
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 120),
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: state.scoreList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 350),
                        columnCount: 2,
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: showchildElement(state.scoreList[index]),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            default:
              return Center(
                  child: Text('错误', style: TextStyle(color: text)));
          }
        }),
      ),
    );
  }

  /// 单个考试卡片
  showchildElement(json) {
    json = jsonDecode(json);
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return GlassCard(
      page: _page,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //序号
              Container(
                width: 24,
                height: 24,
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
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${json["courseName"]}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 13.5,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: text),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(color: text.withValues(alpha: .08), height: 1),
          const SizedBox(height: 4),
          _field('时间', '${json["examTime"]}'.replaceAll(" ", "\n")),
          _field('考场', '${json["examRoom"]}'),
          _field('座位号', '${json["seatNumber"]}'),
        ],
      ),
    );
  }

  /// 字段行：小标签 + 值
  Widget _field(String label, String value) {
    final Color text = GlassTheme.textColor(_page);
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  TextStyle(fontSize: 12, color: text.withValues(alpha: .5))),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                  color: text),
            ),
          ),
        ],
      ),
    );
  }
}
