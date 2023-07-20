import 'package:flutter/material.dart';
import 'package:nnlg/dao/NoticeData.dart';
import 'package:nnlg/utils/ShareDateUtil.dart';

import '../../utils/NoticeUtils.dart';
import '../../utils/ToastUtil.dart';

class showNoticeDialog extends Dialog {
  var _json;

  showNoticeDialog(this._json);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      width: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: _showNoticeDialogMain(_json),
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

class _showNoticeDialogMainState extends State<_showNoticeDialogMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),child: Text(
            '公告',
            style: TextStyle(fontSize: 25),
          ),),
          Expanded(flex: 1,child: ListView(
            children: [
              Padding(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${widget._json['content']}')
                ],
              ),)
            ],
          )),
          Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 130,
                child:  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                    ), child: Text('不再提醒'),onPressed: (){
                  ShareDateUtil().setNoticeId(widget._json['uid']);
                  Navigator.pop(context);
                }),
              ),
              Container(
                width: 130,
                child: ElevatedButton(style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                ), child: Text('取  消'),onPressed: (){
                  Navigator.pop(context);
                }),
              )
            ],
          ),)
        ],
      ),
    );
  }
}
