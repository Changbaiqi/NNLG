import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/markdown.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:nnlg/dao/AppInfoData.dart';
import 'package:nnlg/dao/NoticeData.dart';
import 'package:nnlg/utils/AppUpdateUtil.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/NoticeUtils.dart';
import '../../utils/ToastUtil.dart';

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
  static Future<bool> isLastVersion() async{
    bool result = true;
    await AppUpdateUtil().getAppUpdate().then((json){
        if (json["code"] != 200) {
          ToastUtil.show('${json['msg']}');
          result = true;
          return;
        }
        //如果软件版本递增号高于服务器版本则直接退出
        if (json["data"]["code"] <= AppInfoData.versionNumber.value) {result = true; return;}
        result = false;
    });
    return result;
    // return await AppUpdateUtil().getAppUpdate().then((json){
    //   if (json["code"] != 200) {
    //     ToastUtil.show('${json['msg']}');
    //     return true;
    //   }
    //   //如果软件版本递增号高于服务器版本则直接退出
    //   if (json["data"]["code"] <= AppInfoData.versionNumber) return true;
    // };
    }

  static autoDialog(BuildContext context,int noVersion) {
    AppUpdateUtil().getAppUpdate().then((json) {
      if (json["code"] != 200) {
        ToastUtil.show('${json['msg']}');
        return;
      }

      //如果软件版本递增号高于服务器版本则直接退出
      if (json["data"]["code"] <= AppInfoData.versionNumber.value) return;
      if(json["data"]["code"]==noVersion) return; //屏蔽更新

      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (builder) {
            return WillPopScope(child: Center(
              child: showUpdateDialog(json["data"]),
            ), onWillPop: () async{
              return Future.value(false);
            });
          });
    });
  }





}

class _showUpdateDialogMain extends StatefulWidget {
  var _json;

  _showUpdateDialogMain(this._json);

  //const _showNoticeDialogMain({Key? key}) : super(key: key);

  @override
  State<_showUpdateDialogMain> createState() => _showUpdateDialogMainState();
}

class _showUpdateDialogMainState extends State<_showUpdateDialogMain>  with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _backgroundAnimation; //背景动画
  Animation<double>? _updatePaddingAnimation; //通知移动动画
  Animation<double>? _updateOpacityAnimation; //通知透明动画


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: EdgeInsets.fromLTRB(0, _updatePaddingAnimation!.value, 0, 0),
              child: Opacity(
                opacity: _updateOpacityAnimation!.value,
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
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),child: Text(
                        '发现新版本',
                        style: TextStyle(fontSize: 25),
                      ),),
                      Expanded(flex: 1,child: ListView(
                        children: [
                          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('版本号：',style: TextStyle(fontSize: 15,color: Colors.black54),),
                                Text("v${AppInfoData.version}--->${widget._json["version"]}·${widget._json['mark']}"),
                                Text('版本代号：',style: TextStyle(fontSize: 15,color: Colors.black54),),
                                Text('${widget._json["mark"]}'),
                                Text('更新内容：',style: TextStyle(fontSize: 15,color: Colors.black54),),
                                // Markdown(data: widget._json['content'],physics: NeverScrollableScrollPhysics(),shrinkWrap: true,)
                                MarkdownWidget(data: widget._json['content'],shrinkWrap: true,)
                                // Text('${widget._json['content']}')
                              ],
                            ),)
                        ],
                      )),
                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),child: Column(
                        children: _initButton()
                      ),)
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );





  }

  @override
  void initState() {
    super.initState();
    _backgroundAnimationMethod();
    debugPrint(widget._json.toString());
    debugPrint(AppInfoData.appName.value);
    debugPrint(AppInfoData.version.value);
    debugPrint(AppInfoData.buildNumber.value);

  }
  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }


  List<Widget> _initButton(){
    List<Widget> list=[];
    if(widget._json['fuver']<AppInfoData.versionNumber.value){
      list.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 120,
                child:  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                    ), child: Text('取消'),onPressed: (){
                  // Navigator.pop(context);
                  _animationController!
                      .reverse()
                      .then((value) => Navigator.pop(context));
                }),
              ),

              Container(
                width: 130,
                child:  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                    ), child: Text('不再提示此版本',style: TextStyle(fontSize: 11),),onPressed: (){
                  ShareDateUtil().setNoUpdateVersion(widget._json["code"]);
                  _animationController!
                      .reverse()
                      .then((value) => Navigator.pop(context));
                }),
              )
            ],
          )
      );
  }


    list.add( Container(
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent)
      ), child: Text('更新'),onPressed: () async {
        //launchUrl(Uri.parse('${widget._json['url']}',));
        if (await canLaunch('${widget._json['url']}')) {
          await launch('${widget._json['url']}');
        } else {
          throw 'Could not launch ${widget._json['url']}';
        }
      }),
    ));
    return list;
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
