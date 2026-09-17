import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/main_community_view/view.dart';
import 'package:callo/view/main_course_view/view.dart';
import 'package:callo/view/main_user_view/view.dart';
import 'package:callo/view/main_water_view/view.dart';
import 'package:callo/view/nnlg_community_view/view.dart';

import 'logic.dart';

/// 主框架：毛玻璃悬浮底部导航 + 渐变课表按钮
class MainViewPage extends StatelessWidget {
  MainViewPage({Key? key}) : super(key: key);
  final logic = Get.find<MainViewLogic>();
  final state = Get.find<MainViewLogic>().state;

  final List<Widget> _viewList = [
    MainCommunityViewPage(),
    MainWaterViewPage(),
    MainCourseViewPage(),
    NnlgCommunityViewPage(),
    MainUserViewPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      //Tab 切换（PageView 滑动）期间临时关闭毛玻璃模糊：
      //BackdropFilter 跟随页面位移每帧都要重新采样，是切换掉帧的主因。
      //depth==0 只针对 PageView 本身，页面内列表滚动不受影响。
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth != 0) return false;
          if (notification is ScrollStartNotification) {
            glassBlurSuppress.value = true;
          } else if (notification is ScrollEndNotification) {
            glassBlurSuppress.value = false;
          }
          return false;
        },
        child: PageView(
          //预构建相邻页，避免开始滑动的瞬间才构建整页导致卡顿
          allowImplicitScrolling: true,
          children: _viewList
              .map((page) => RepaintBoundary(child: page))
              .toList(),
          controller: state.pageController.value,
          onPageChanged: (indexPage) {
            state.index.value = indexPage;
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _scheduleFab(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// 毛玻璃胶囊导航栏
  Widget _bottomBar() {
    final bool dark = GlassTheme.isDark('main_view');
    // 半透明主题色 + 强模糊：保留通透的毛玻璃感，同时前景色按合成色推导保证可读
    final Color surface = GlassTheme.glassTint('main_view')
        .withValues(alpha: GlassTheme.glassAlpha('main_view'));
    final Widget bar = Container(
            height: 68,
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: dark
                    ? Colors.white.withValues(alpha: .16)
                    : Colors.white.withValues(alpha: .85),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: dark ? .36 : .10),
                  blurRadius: 26,
                  offset: const Offset(0, 12),
                )
              ],
            ),
            child: Row(
              children: [
                _navItem(0, Icons.explore_rounded, '主页'),
                _navItem(1, Icons.water_drop_rounded, '打水'),
                const SizedBox(width: 76),
                _navItem(3, Icons.forum_rounded, '社区'),
                _navItem(4, Icons.person_rounded, '我的'),
              ],
            ),
          );
    //转场期间跳过模糊，页面停稳后再恢复毛玻璃（避免切换页面掉帧）
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: GlassBlurGate(
          builder: (blurred) => blurred
              ? BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 32, sigmaY: 32),
                  child: bar,
                )
              : bar,
        ),
      ),
    );
  }

  /// 单个导航项：按表面亮度保证对比度，选中时渐变高亮
  Widget _navItem(int index, IconData icon, String label) {
    final Color base = GlassTheme.pageBackground('main_view');
    final Color surface = GlassTheme.glassSurfaceOn('main_view', base);
    final Color fg = GlassTheme.onSurface(surface);
    final Color selectColor = GlassTheme.readableAccent(
        GlassTheme.bottomNav('selectColor', GlassTokens.accent), surface);
    final Color nonSelectColor = fg.withValues(alpha: .55);
    final Color labelColor = fg.withValues(alpha: .78);

    return Expanded(
      child: Obx(() {
        final bool selected = state.index.value == index;
        final Color color = selected ? selectColor : nonSelectColor;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => logic.animationJumpToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: selected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            selectColor.withValues(alpha: .26),
                            selectColor.withValues(alpha: .08),
                          ],
                        )
                      : null,
                  border: selected
                      ? Border.all(
                          color: selectColor.withValues(alpha: .38), width: 1)
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedScale(
                      scale: selected ? 1.08 : 1,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      child: Icon(icon, size: 22, color: color),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      label,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: selected ? selectColor : labelColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 中间课表按钮：渐变 + 柔光
  Widget _scheduleFab() {
    final bool dark = GlassTheme.isDark('main_view');
    final Color accent =
        GlassTheme.bottomNav('selectScheduleColor', GlassTokens.accent);
    //中间按钮带渐变底色 + 自适应图标色，不需要为了文字对比度把主题色压暗，
    //浅色主题下按主题色提亮，避免颜色过深和页面不搭
    final Color selectColor = GlassTheme.lighten(accent, dark ? .08 : .14);
    //未在课表页时：用主题强调色的淡色（不再是灰色），和整体主题统一
    final Color nonSelectColor = Color.alphaBlend(
      accent.withValues(alpha: dark ? .32 : .16),
      GlassTheme.pageBackground('main_view'),
    );
    return Obx(() {
      final bool selected = state.index.value == 2;
      final Color color = selected ? selectColor : nonSelectColor;
      final Color iconColor = color.computeLuminance() > .6
          ? const Color(0xFF1C1B20)
          : Colors.white;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, GlassTheme.lighten(color, .38)],
          ),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: .35),
              blurRadius: 20,
              offset: const Offset(0, 9),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => logic.animationJumpToPage(2),
          backgroundColor: Colors.transparent,
          shape: const CircleBorder(),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          child: Icon(Icons.calendar_month_rounded, color: iconColor),
        ),
      );
    });
  }
}
