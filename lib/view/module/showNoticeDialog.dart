import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/widget/markdown.dart';

// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nnlg/dao/NoticeData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';

import '../../utils/NoticeUtils.dart';
import '../../utils/ToastUtil.dart';

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

  //const _showNoticeDialogMain({Key? key}) : super(key: key);

  @override
  State<_showNoticeDialogMain> createState() => _showNoticeDialogMainState();
}

class _showNoticeDialogMainState extends State<_showNoticeDialogMain>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _noticePaddingAnimation; //通知移动动画
  Animation<double>? _noticeOpacityAnimation; //通知透明动画

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        child: Stack(
          children: [
            Align(
              child: InkWell(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                      sigmaX: _backgroundAnimation!.value,
                      sigmaY: _backgroundAnimation!.value),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                  ),
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
                    constraints: BoxConstraints(
                      minHeight: 340,
                      maxHeight: 500,
                    ),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 247, 242, 249),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black45, blurRadius: 10, offset: Offset(1, 1))
                        ]),
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          child: Text(
                            '公告',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          // child: Markdown(data: widget._json['content'],),
                          child: MarkdownWidget(
                            data: widget._json['content'],
                            shrinkWrap: true,
                          ),
                        )),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 130,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blueGrey)),
                                    child: Text('不再提醒'),
                                    onPressed: () {
                                      ShareDateUtil()
                                          .setNoticeId(widget._json['uid']);
                                      // Navigator.pop(context);
                                      _animationController!
                                          .reverse()
                                          .then((value) => Navigator.pop(context));
                                    }),
                              ),
                              Container(
                                width: 130,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.blueGrey)),
                                    child: Text('取  消'),
                                    onPressed: () {
                                      _animationController!
                                          .reverse()
                                          .then((value) => Navigator.pop(context));
                                    }),
                              )
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
