import 'package:flutter/material.dart';
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
    return Container(
      height: 340,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: _showUpdateDialogMain(_json),
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
        if (json["data"]["code"] <= AppInfoData.versionNumber) {result = true; return;}
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

  static autoDialog(BuildContext context) {
    AppUpdateUtil().getAppUpdate().then((json) {
      if (json["code"] != 200) {
        ToastUtil.show('${json['msg']}');
        return;
      }
      //如果软件版本递增号高于服务器版本则直接退出
      if (json["data"]["code"] <= AppInfoData.versionNumber) return;

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

class _showUpdateDialogMainState extends State<_showUpdateDialogMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
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
                  Text('${widget._json['content']}')
                ],
              ),)
            ],
          )),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _initButton(),
          ),)
        ],
      ),
    );





  }

  @override
  void initState() {
    debugPrint(widget._json.toString());
    debugPrint(AppInfoData.appName);
    debugPrint(AppInfoData.version);
    debugPrint(AppInfoData.buildNumber);

  }



  List<Widget> _initButton(){
    List<Widget> list=[];
    if(widget._json['fuver']<AppInfoData.versionNumber){
      list.add(
          Container(
            width: MediaQuery.of(context).size.width/3,
            child:  ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                ), child: Text('取消'),onPressed: (){
              Navigator.pop(context);
            }),
          )
      );
  }


    list.add( Container(
      width: MediaQuery.of(context).size.width/3,
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
}
