import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 成绩查询：毛玻璃 + 渐变风格
class ScoreInquiryViewPage extends StatelessWidget {
  ScoreInquiryViewPage({Key? key}) : super(key: key);

  final logic = Get.find<ScoreInquiryViewLogic>();
  final state = Get.find<ScoreInquiryViewLogic>().state;

  static const String _page = 'score_inquiry_view';

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
              Text('成绩查询',
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
                          columnCount: state.scoreList.length,
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: showchildElement(state.scoreList[index]),
                            ),
                          ));
                    },
                  ),
                ],
              );
            default:
              return Center(
                child: Text('错误', style: TextStyle(color: text)),
              );
          }
        }),
      ),
    );
  }

  /// 单个成绩卡片
  showchildElement(json) {
    json = jsonDecode(json);
    final Color text = GlassTheme.textColor(_page);
    //分数底色：原白色占位改用主题强调色；文字颜色按底色亮度自动取黑/白，保证可读
    final Color rawScoreColor = logic.scoreColors(json['courseScore']);
    final Color badgeColor = rawScoreColor.computeLuminance() > .9
        ? GlassTheme.accentColor(_page)
        : rawScoreColor;
    final Color badgeTextColor = GlassTheme.onSurface(badgeColor);
    return GlassCard(
      page: _page,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              //成绩圆环（按分数着色）
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      badgeColor,
                      GlassTheme.lighten(badgeColor, .22),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: badgeColor.withValues(alpha: .35),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    '${json["courseScore"]}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: badgeTextColor),
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: text.withValues(alpha: .06),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '第${json["number"]}条',
                  style:
                      TextStyle(fontSize: 11, color: text.withValues(alpha: .6)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _field('科目', '${json["courseName"]}'),
          const SizedBox(height: 5),
          _field('编号', '${json["courseNumber"]}'),
          const SizedBox(height: 5),
          _field('时间', '${json["time"]}'),
        ],
      ),
    );
  }

  /// 字段行：小标签 + 值
  Widget _field(String label, String value) {
    final Color text = GlassTheme.textColor(_page);
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
