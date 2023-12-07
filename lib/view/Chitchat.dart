import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/utils/ChitchatUtil.dart';

class Chitchat extends StatefulWidget {
  const Chitchat({Key? key}) : super(key: key);

  @override
  State<Chitchat> createState() => _ChitchatState();
}

class _ChitchatState extends State<Chitchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('聊天室',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: ChatInterFace(),
      ),
    );
  }
}

class ChatInterFace extends StatefulWidget {
  const ChatInterFace({Key? key}) : super(key: key);

  @override
  State<ChatInterFace> createState() => _ChatInterFaceState();
}

class _ChatInterFaceState extends State<ChatInterFace> {
  late ChitchatUtil chitchatUtil;

  TextEditingController sendTextEdit = TextEditingController();

  ScrollController listScrollController = ScrollController();

  List<Widget> msgList = [];

  int historyMsgNum = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //聊天内容
        Expanded(
          flex: 1,
          child: EasyRefresh(
            onRefresh: () async{
              this._loadHistoryMessage();
            },
            // onLoad: () async{
            //
            // },
            child: ListView.builder(
              // reverse: true,
              shrinkWrap: true,
              controller: listScrollController,
              itemCount: msgList.length,
              itemBuilder: (context, index) {
                // var item = msgList[index];
                return msgList[index];
              },
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Container(
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        controller: sendTextEdit,
                        maxLines: 5,
                        minLines: 1,
                        decoration: const InputDecoration(
                            hintText: '请输入需要发送的信息',
                            border: const OutlineInputBorder(
                              gapPadding: 0,
                              borderSide: BorderSide(
                                width: 1,
                                style: BorderStyle.none
                              )
                            ),
                            fillColor: Colors.black12,
                            filled: true,
                            isDense: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)))),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: Container(
                  height: 45,
                  child: ElevatedButton(
                    child: Text('发送'),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(BeveledRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5)))), //圆角弧度
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                    onPressed: () {
                      chitchatUtil.send(sendTextEdit.text);
                      sendTextEdit.text = '';
                    },
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget tpMessageChild(String userId, String text) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${userId}'),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxWidth: MediaQuery.of(context).size.width / 1.3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: SelectableText('${text}'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget meMessageChild(String userId, String text) {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('${userId}'),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxWidth: MediaQuery.of(context).size.width / 1.3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: SelectableText('${text}'),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/user.jpg',
                  height: 50,
                  width: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 提示消息
   */
  Widget hintMessage(String msg) {
    return Container(
      child: Center(
        child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Container(
          constraints: BoxConstraints(minWidth: 100, minHeight: 30),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(msg)
              ],
            ),
          ),
        ),),
      ),
    );
  }

  msgListening() async {
    chitchatUtil.getChannel().stream.listen((event) {
      print('${event}');
      var json = jsonDecode(event);

      if (json['code'] == 200 || json['code'] == 201) {
        setState(() {
          msgList.add(hintMessage('${json['msg']}'));
        });
        Timer(
            Duration(milliseconds: 100),
                () => listScrollController
                .jumpTo(listScrollController.position.maxScrollExtent));
      } else if (json['code'] == 202) {
        setState(() {
          if (json['userId'] == AccountData.studentID)
            msgList.add(meMessageChild(json['userId'], json['msg']));
          else
            msgList.add(tpMessageChild(json['userId'], json['msg']));
        });
        Timer(
            Duration(milliseconds: 100),
                () => listScrollController
                .jumpTo(listScrollController.position.maxScrollExtent));
      } else if(json['code']== 203){
        List msgList = json['data'];

        setState((){
          msgList.forEach((element) {
            // print('${element}');
            if (element['userId'] == AccountData.studentID)
              this.msgList.insert(0,meMessageChild(element['userId'], element['msg']));
            else
              this.msgList.insert(0,tpMessageChild(element['userId'], element['msg']));
            historyMsgNum = historyMsgNum == 0 || historyMsgNum > element['id'] ? element['id'] : historyMsgNum;
          });
        });
      }

    }, onError: (error) {
      chitchatUtil.getChannel().sink.close();
    }, onDone: () async {
      chitchatUtil = ChitchatUtil();
    });
  }

  _loadHistoryMessage() async {
    Map result = {
      "code": 200,
      "id": this.historyMsgNum
    };

    chitchatUtil.channel.sink.add(jsonEncode(result));
  }

  @override
  void initState() {
    chitchatUtil = ChitchatUtil();
    msgListening();
  }

  @override
  void dispose() {
    chitchatUtil.close();
    super.dispose();
  }
}
