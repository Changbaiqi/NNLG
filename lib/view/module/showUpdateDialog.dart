import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:callo/dao/AppInfoData.dart';
import 'package:callo/utils/AppUpdateUtil.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';

import '../../utils/ToastUtil.dart';

/// 更新弹窗：毛玻璃 + 渐变风格
class showUpdateDialog extends Dialog {
  var _json;

  showUpdateDialog(this._json);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        alignment: Alignment.center,
        child: _showUpdateDialogMain(_json),
      ),
    );
  }

  //此函数用于检测当前版本是否为最新版
  static Future<bool> isLastVersion() async {
    bool result = true;
    await AppUpdateUtil().getAppUpdate().then((json) {
      if (json["code"] != 200) {
        ToastUtil.show('${json['msg']}');
        result = true;
        return;
      }
      //如果软件版本递增号高于服务器版本则直接退出
      if (json["data"]["code"] <= AppInfoData.versionNumber.value) {
        result = true;
        return;
      }
      result = false;
    });
    return result;
  }

  static autoDialog(BuildContext context, int noVersion) {
    AppUpdateUtil().getAppUpdate().then((json) {
      if (json["code"] != 200) {
        ToastUtil.show('${json['msg']}');
        return;
      }

      //如果软件版本递增号高于服务器版本则直接退出
      if (json["data"]["code"] <= AppInfoData.versionNumber.value) return;
      if (json["data"]["code"] == noVersion) return; //屏蔽更新

      showDialog(
          useRootNavigator: false,
          barrierDismissible: false,
          context: context,
          builder: (builder) {
            return WillPopScope(
                child: Center(
                  child: showUpdateDialog(json["data"]),
                ),
                onWillPop: () async {
                  return Future.value(false);
                });
          });
    });
  }
}

class _showUpdateDialogMain extends StatefulWidget {
  var _json;

  _showUpdateDialogMain(this._json);

  @override
  State<_showUpdateDialogMain> createState() => _showUpdateDialogMainState();
}

class _showUpdateDialogMainState extends State<_showUpdateDialogMain>
    with SingleTickerProviderStateMixin {
  static const String _page = 'showUpdateDialog';

  AnimationController? _animationController;
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _updatePaddingAnimation; //通知移动动画
  Animation<double>? _updateOpacityAnimation; //通知透明动画

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Align(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: _backgroundAnimation!.value,
                      sigmaY: _backgroundAnimation!.value),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, _updatePaddingAnimation!.value, 0, 0),
                  child: Opacity(
                    opacity: _updateOpacityAnimation!.value,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 340,
                        maxHeight: 520,
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                            child:
                                GlassSectionTitle(page: _page, title: '发现新版本'),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              children: [
                                _label('版本号'),
                                Text(
                                  "v${AppInfoData.version}  →  ${widget._json["version"]}·${widget._json['mark']}",
                                  style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: text),
                                ),
                                const SizedBox(height: 10),
                                _label('版本代号'),
                                Text('${widget._json["mark"]}',
                                    style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                        color: text)),
                                const SizedBox(height: 10),
                                _label('更新内容'),
                                MarkdownWidget(
                                  data: widget._json['content'],
                                  shrinkWrap: true,
                                  config: MarkdownConfig(configs: [
                                    PConfig(
                                        textStyle: TextStyle(color: text)),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Column(children: _initButton(text)),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _label(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                color: GlassTheme.textColor(_page).withValues(alpha: .55))),
      );

  List<Widget> _initButton(Color text) {
    List<Widget> list = [];
    if (widget._json['fuver'] < AppInfoData.versionNumber.value) {
      list.add(Row(
        children: [
          Expanded(
            child: _softButton(
              text: '取消',
              color: text,
              onPressed: () {
                _animationController!
                    .reverse()
                    .then((value) => Navigator.pop(context));
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _softButton(
              text: '不再提示此版本',
              color: text,
              fontSize: 12,
              onPressed: () {
                ShareDateUtil().setNoUpdateVersion(widget._json["code"]);
                _animationController!
                    .reverse()
                    .then((value) => Navigator.pop(context));
              },
            ),
          )
        ],
      ));
      list.add(const SizedBox(height: 10));
    }

    list.add(GradientButton(
      text: '立即更新',
      icon: Icons.system_update_alt_rounded,
      page: _page,
      height: 46,
      onPressed: () async {
        if (await canLaunch('${widget._json['url']}')) {
          await launch('${widget._json['url']}');
        } else {
          throw 'Could not launch ${widget._json['url']}';
        }
      },
    ));
    return list;
  }

  /// 次要按钮：轻描边玻璃样式
  Widget _softButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
    double fontSize = 13.5,
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
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: .85))),
            ),
          ),
        ),
      ),
    );
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

    _updatePaddingAnimation =
        Tween(begin: 100.0, end: 0.0).animate(_animationController!);

    _updateOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(_animationController!);

    _animationController!.forward(); //向前播放动画
  }
}
