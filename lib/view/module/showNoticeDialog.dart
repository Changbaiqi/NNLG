import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:callo/dao/NoticeData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';

import '../../utils/NoticeUtils.dart';
import '../../utils/ToastUtil.dart';

/// 公告弹窗：毛玻璃 + 渐变风格
class showNoticeDialog extends Dialog {
  var _json;

  showNoticeDialog(this._json);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        child: _showNoticeDialogMain(_json),
      ),
    );
  }

  static autoDialog(BuildContext context) {
    NoticeUtil().getNotice().then((json) {
      if (json["code"] != 200) {
        ToastUtil.show('${json['msg']}');
        return;
      }
      //如果通知寄存版本高于服务器版本则直接退出
      if (json["data"]["uid"] <= NoticeData.noticeId) return;

      showDialog(
          useRootNavigator: false,
          barrierColor: Colors.transparent,
          context: context,
          builder: (builder) {
            return Center(
              child: showNoticeDialog(json["data"]),
            );
          });
    });
  }
}

class _showNoticeDialogMain extends StatefulWidget {
  var _json;

  _showNoticeDialogMain(this._json);

  @override
  State<_showNoticeDialogMain> createState() => _showNoticeDialogMainState();
}

class _showNoticeDialogMainState extends State<_showNoticeDialogMain>
    with SingleTickerProviderStateMixin {
  static const String _page = 'main_view';

  AnimationController? _animationController;
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _noticePaddingAnimation; //通知移动动画
  Animation<double>? _noticeOpacityAnimation; //通知透明动画

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
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
                          alpha: .32 *
                              (_backgroundAnimation!.value / 20).clamp(0, 1)),
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, _noticePaddingAnimation!.value, 0, 0),
                    child: Opacity(
                      opacity: _noticeOpacityAnimation!.value,
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 340,
                          maxHeight: 500,
                        ),
                        width: 300,
                        decoration: BoxDecoration(
                          color: GlassTheme.pageBackground(_page)
                              .withValues(alpha: .94),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: GlassTheme.border(_page), width: 1),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withValues(alpha: .18),
                                blurRadius: 24,
                                offset: const Offset(0, 12))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 18, 20, 0),
                              child: GlassSectionTitle(
                                  page: _page, title: '公告'),
                            ),
                            Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 10, 16, 0),
                                  child: MarkdownWidget(
                                    data: widget._json['content'],
                                    shrinkWrap: true,
                                    config: MarkdownConfig(configs: [
                                      PConfig(textStyle: TextStyle(color: text)),
                                    ]),
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _softButton(
                                      text: '不再提醒',
                                      color: text,
                                      onPressed: () {
                                        ShareDateUtil()
                                            .setNoticeId(widget._json['uid']);
                                        _animationController!.reverse().then(
                                            (value) => Navigator.pop(context));
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: GradientButton(
                                      text: '知道了',
                                      page: _page,
                                      height: 42,
                                      onPressed: () {
                                        _animationController!.reverse().then(
                                            (value) => Navigator.pop(context));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
        ));
  }

  /// 次要按钮：轻描边玻璃样式
  Widget _softButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 42,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: color.withValues(alpha: .06),
              border: Border.all(color: color.withValues(alpha: .18)),
            ),
            child: Center(
              child: Text(text,
                  style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: .85))),
            ),
          ),
        ),
      ),
    );
  }

  /**
   * [title]
   * [author] 长白崎
   * [description] TODO 动画
   * [date] 18:44 2024/2/12
   * [param] null
   * [return]
   */
  _backgroundAnimationMethod() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..reverse();
    _animationController!.addListener(() {
      setState(() {});
    });

    CurvedAnimation(parent: _animationController!, curve: Curves.decelerate);

    _backgroundAnimation =
        Tween(begin: 0.0, end: 20.0).animate(_animationController!);

    _noticePaddingAnimation =
        Tween(begin: 100.0, end: 0.0).animate(_animationController!);

    _noticeOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    _animationController!.forward(); //向前播放动画
  }

  @override
  void initState() {
    super.initState();
    _backgroundAnimationMethod();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }
}
