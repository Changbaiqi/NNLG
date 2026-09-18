import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/main_community_view/view.dart';
import 'package:callo/view/main_course_view/view.dart';
import 'package:callo/view/main_user_view/view.dart';
import 'package:callo/view/main_water_view/view.dart';
import 'package:callo/view/nnlg_community_view/view.dart';

import 'logic.dart';

/// 主框架：M3 悬浮底部导航 + 课表 FAB
class MainViewPage extends StatefulWidget {
  MainViewPage({Key? key}) : super(key: key);

  @override
  State<MainViewPage> createState() => _MainViewPageState();
}

class _MainViewPageState extends State<MainViewPage>
    with SingleTickerProviderStateMixin {
  final logic = Get.find<MainViewLogic>();
  final state = Get.find<MainViewLogic>().state;

  /// Tab 页面每次 build 重新创建：
  /// 如果缓存在 State 里，主题切换时内部组件不会被重建，颜色就不会刷新
  List<Widget> _buildViewList() => [
        MainCommunityViewPage(),
        MainWaterViewPage(),
        MainCourseViewPage(),
        NnlgCommunityViewPage(),
        MainUserViewPage(),
      ];

  /// 点击导航切页时的柔和淡入（无左右位移）
  late final AnimationController _pageFade = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
    value: 1,
  );

  @override
  void dispose() {
    _pageFade.dispose();
    super.dispose();
  }

  /// 导航点击：直接切页 + 淡入过渡
  void _jumpToPage(int index) {
    logic.animationJumpToPage(index);
    _pageFade.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          //Tab 切换（PageView 滑动）期间临时关闭毛玻璃模糊：
          //BackdropFilter 跟随页面位移每帧都要重新采样，是切换掉帧的主因。
          //depth==0 只针对 PageView 本身，页面内列表滚动不受影响。
          NotificationListener<ScrollNotification>(
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
              //显式使用 PageScrollPhysics：否则会被全局弹性物理覆盖，
              //拖拽松手后可能停在两页之间，表现为"页面卡住"
              physics:
                  const PageScrollPhysics(parent: ClampingScrollPhysics()),
              children: _buildViewList()
                  .map((page) => RepaintBoundary(child: page))
                  .toList(),
              controller: state.pageController.value,
              onPageChanged: (indexPage) {
                state.index.value = indexPage;
              },
            ),
          ),
          //点击导航后的柔和过渡：新页面从底色淡入（无左右移动、无阴影）
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _pageFade,
                builder: (_, __) => _pageFade.value >= 1
                    ? const SizedBox.shrink()
                    : Opacity(
                        opacity: ((1 - _pageFade.value) * .9).clamp(0, 1),
                        child: ColoredBox(color: CustomThemeData.pageColor),
                      ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _scheduleFab(),
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// Material 3 导航栏：surfaceContainer 底 + 选中态 secondaryContainer 指示
  Widget _bottomBar() {
    final ColorScheme scheme = GlassTheme.scheme;
    final Widget bar = Container(
      height: 68,
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: .5),
          width: .5,
        ),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withValues(alpha: .16),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: bar,
    );
  }

  /// 当前按下的导航项（用于按下缩放反馈）
  int? _pressedNavIndex;

  /// 单个导航项：M3 选中态用 secondaryContainer 胶囊指示 + 按下缩放
  Widget _navItem(int index, IconData icon, String label) {
    final ColorScheme scheme = GlassTheme.scheme;
    return Expanded(
      child: Obx(() {
        final bool selected = state.index.value == index;
        final Color color =
            selected ? scheme.onSecondaryContainer : scheme.onSurfaceVariant;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _jumpToPage(index),
              onTapDown: (_) =>
                  setState(() => _pressedNavIndex = index),
              onTapUp: (_) => setState(() => _pressedNavIndex = null),
              onTapCancel: () => setState(() => _pressedNavIndex = null),
              child: AnimatedScale(
                scale: _pressedNavIndex == index ? .94 : 1.0,
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                      selected ? scheme.secondaryContainer : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //图标/文字颜色也做过渡，避免旧项高亮"闪一下"瞬间消失
                    TweenAnimationBuilder<Color?>(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      tween: ColorTween(end: color),
                      builder: (_, Color? animated, __) =>
                          Icon(icon, size: 22, color: animated ?? color),
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            selected ? FontWeight.w700 : FontWeight.w500,
                        color: color,
                      ),
                      child: Text(label, maxLines: 1),
                    ),
                  ],
                ),
              ),
              ),
            ),
          ),
        );
      }),
    );
  }

  /// 中间课表按钮：M3 FAB（选中页 → primary，其它页 → primaryContainer）
  Widget _scheduleFab() {
    final ColorScheme scheme = GlassTheme.scheme;
    return Obx(() {
      final bool selected = state.index.value == 2;
      final Color bg = selected ? scheme.primary : scheme.primaryContainer;
      final Color fg = selected ? scheme.onPrimary : scheme.onPrimaryContainer;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          boxShadow: [
            BoxShadow(
              color: scheme.shadow.withValues(alpha: .22),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: FloatingActionButton(
          onPressed: () => _jumpToPage(2),
          //禁用 Hero：主页与内嵌的社区页各有一个 FAB，
          //默认 tag 相同会导致页面切换时 Hero 冲突崩溃
          heroTag: null,
          backgroundColor: Colors.transparent,
          foregroundColor: fg,
          shape: const CircleBorder(),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            tween: ColorTween(end: fg),
            builder: (_, Color? animated, __) => Icon(
                Icons.calendar_month_rounded, color: animated ?? fg),
          ),
        ),
      );
    });
  }
}
