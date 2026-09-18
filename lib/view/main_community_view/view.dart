import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/ContextData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/module/showBindPowerDialog.dart';
import 'package:callo/view/router/Routes.dart';

import 'logic.dart';

/// 主页（社区）：毛玻璃 + 渐变风格
class MainCommunityViewPage extends StatelessWidget {
  MainCommunityViewPage({Key? key}) : super(key: key);
  final logic = Get.put(MainCommunityViewLogic());
  final state = Get.find<MainCommunityViewLogic>().state;

  static const String _page = 'main_community_view';

  @override
  Widget build(BuildContext context) {
    logic.context = context;
    return Obx(() => Scaffold(
          backgroundColor: GlassTheme.pageBackground(_page),
          body: GlassBackground(
            page: _page,
            //适配状态栏/挖孔摄像头：内容下移，渐变背景保持全屏
            child: SafeArea(
              bottom: false,
              child: ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: [
                _statCard(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child:
                      GlassSectionTitle(page: _page, title: '常用功能'),
                ),
                _functionGrid(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                  child: GlassSectionTitle(page: _page, title: '宿舍电费'),
                ),
                GlassCard(
                  page: _page,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: logic.bindDormCard(),
                ),
              ],
            ),
            ),
          ),
        ));
  }

  /// 顶部统计（在线人数 / 软件点击量）
  Widget _statCard() {
    final Color divider = GlassTheme.textColor(_page).withValues(alpha: .12);
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => GlassStat(
                page: _page,
                value: '',
                label: '在线人数',
                icon: Icons.people_alt_rounded,
                valueWidget: AnimatedFlipCounter(
                  value: ContextDate.onLineTotalCount.value.toInt(),
                  textStyle: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: GlassTheme.scheme.primary),
                ),
              )),
          Container(width: 1, height: 44, color: divider),
          Obx(() => GlassStat(
                page: _page,
                value: '',
                label: '软件点击量',
                icon: Icons.touch_app_rounded,
                valueWidget: AnimatedFlipCounter(
                  value: state.onClickTotal.value.toInt(),
                  textStyle: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: GlassTheme.scheme.primary),
                ),
              )),
        ],
      ),
    );
  }

  /// 常用功能九宫格
  Widget _functionGrid() {
    return GlassCard(
      page: _page,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 1.3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: [
          _gridItem(
            child: logic.boxChildLottie(
                'assets/images/chat_room_lottie.json', '校园聊一聊'),
            onTap: () => Get.toNamed(Routes.ChitChat),
          ),
          _gridItem(
            child: logic.boxChildLottie(
                'assets/images/exam_plan_lottie.json', '考试安排'),
            onTap: () => Get.toNamed(Routes.ExamInquiry),
          ),
          _gridItem(
            child: logic.boxChildSvg(
                'assets/images/dorm.svg', '宿舍电费预警'),
            onTap: () {
              showDialog(
                  useRootNavigator: false,
                  context: logic.context!,
                  builder: (builder) {
                    return Center(child: showBindPowerDialog());
                  });
            },
          ),
          _gridItem(
            child: logic.boxChildSvg(
                'assets/images/train_plan.svg', '培养计划'),
            onTap: () => Get.toNamed(Routes.TrainPlan),
          ),
          _gridItem(
            child: logic.boxChildLottie(
                'assets/images/score_search_lottie.json', '成绩查询'),
            onTap: () => Get.toNamed(Routes.ScoreInquiry),
          ),
          _gridItem(
            child: logic.boxChildLottie(
                'assets/images/evaluate_lottie.json', '教学评价'),
            onTap: () => Get.toNamed(Routes.TeachingEva),
          ),
        ],
      ),
    );
  }

  Widget _gridItem({required Widget child, required VoidCallback onTap}) {
    return GlassIconTile(page: _page, onTap: onTap, child: child);
  }
}
