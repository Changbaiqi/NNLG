import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/utils/GlassUI.dart';
import 'package:callo/view/router/Routes.dart';

/// 共享课表选择弹窗：毛玻璃 + 渐变圆形按钮
class showCourseSharedSelectDialog extends Dialog {
  static const String _page = 'main_course_view';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _CourseSharedSelect(),
    );
  }
}

class _CourseSharedSelect extends StatefulWidget {
  const _CourseSharedSelect({Key? key}) : super(key: key);

  @override
  State<_CourseSharedSelect> createState() => _CourseSharedSelectState();
}

class _CourseSharedSelectState extends State<_CourseSharedSelect>
    with SingleTickerProviderStateMixin {
  static const String _page = 'main_course_view';

  AnimationController? _animationController; //动画控制器
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _topButtonAnimation;
  Animation<double>? _bottomButtonAnimation; //底部按钮
  Animation<double>? _buttonOpacityAnimation;

  @override
  Widget build(BuildContext context) {
    final Color accent = GlassTheme.accentColor(_page);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        child: Stack(
          children: [
            Align(
              child: InkWell(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withValues(
                      alpha:
                          .32 * (_backgroundAnimation!.value / 20).clamp(0, 1)),
                ),
                onTap: () {
                  _animationController!
                      .reverse()
                      .then((value) => Navigator.pop(context));
                },
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, 0, 0, _topButtonAnimation!.value),
                    child: Opacity(
                      opacity: _buttonOpacityAnimation!.value,
                      child: _actionCircle(
                        label: '查询',
                        icon: Icons.search_rounded,
                        colors: [accent, GlassTheme.lighten(accent, .35)],
                        onTap: () {
                          Get.toNamed(Routes.SharedCourseChoose);
                          _animationController!
                              .reverse()
                              .then((value) => Navigator.pop(context));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(0, _bottomButtonAnimation!.value, 0, 0),
                    child: Opacity(
                      opacity: _buttonOpacityAnimation!.value,
                      child: _actionCircle(
                        label: '共享',
                        icon: Icons.ios_share_rounded,
                        colors: [
                          GlassTheme.scheme.tertiary,
                          GlassTheme.lighten(GlassTheme.scheme.tertiary, .28)
                        ],
                        onTap: () {
                          Get.toNamed(Routes.CourseShared);
                          _animationController!
                              .reverse()
                              .then((value) => Navigator.pop(context));
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        onWillPop: () async {
          _animationController!
              .reverse()
              .then((value) => Navigator.pop(context));
          return false;
        },
      ),
    );
  }

  /// 渐变圆形动作按钮
  Widget _actionCircle({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 112,
      width: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withValues(alpha: .40),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: GlassTheme.onSurface(colors.first), size: 30),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      color: GlassTheme.onSurface(colors.first),
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 动画
   * [date] 17:53 2024/2/12
   * [param] null
   * [return]
   */
  backgroundAnimation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));

    CurvedAnimation(parent: _animationController!, curve: Curves.decelerate); //动画效果
    _animationController!.addListener(() {
      setState(() {});
    });

    //背景动画
    _backgroundAnimation =
        Tween(begin: 0.0, end: 20.0).animate(_animationController!); //动画绑定值

    _topButtonAnimation =
        Tween(begin: 30.0, end: 10.0).animate(_animationController!); //顶部按钮
    _buttonOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!); //透明度

    _bottomButtonAnimation =
        Tween(begin: 20.0, end: 10.0).animate(_animationController!); //底部按钮

    _animationController!.forward();
  }

  @override
  void initState() {
    super.initState();
    backgroundAnimation();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
