import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

import 'logic.dart';

class ChitChatViewPage extends StatelessWidget {
  ChitChatViewPage({Key? key}) : super(key: key);
  final logic = Get.put(ChitChatViewLogic());
  final state = Get.find<ChitChatViewLogic>().state;
  @override
  Widget build(BuildContext context) {
    state.context = context;
    
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('聊天室',style: TextStyle(color: Colors.black),),
      ),
      body: Container(
        child: Column(
          children: [
            //聊天内容
            Expanded(
              flex: 1,
              child: EasyRefresh(
                onRefresh: () async{
                  logic.loadHistoryMessage();
                },
                // onLoad: () async{
                //
                // },
                child: Obx(()=>ListView.builder(
                  // reverse: true,
                  shrinkWrap: true,
                  controller: state.listScrollController.value,
                  itemCount: state.msgList.value.length,
                  itemBuilder: (context, index) {
                    // var item = msgList[index];
                    return messageChild(state.msgList.value[index]);
                  },
                )),
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
                            controller: state.sendTextEdit,
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
                          state.chitchatUtil.send(state.sendTextEdit.text);
                          state.sendTextEdit.text = '';
                          Timer(
                              Duration(milliseconds: 500),
                                  (){
                                state.listScrollController.value
                                    .jumpTo(state.listScrollController.value.position.maxScrollExtent);
                              });

                        },
                      ),
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


  /**
   * 消息展示整合
   */
  Widget messageChild(messageJson){
    switch(messageJson['showType']){
      case 0:
        return tpMessageChild(messageJson);
      case 1:
        return meMessageChild(messageJson);
      case 2:
        return hintMessage(messageJson);
      default:
        return hintMessage({"text": "未知信息类型"});
    }
  }

  /**
   * 左显示
   */
  Widget tpMessageChild(messageJson) {
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
                      Text('${messageJson['userId']}'),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxWidth: MediaQuery.of(state.context!).size.width / 1.3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: SelectableText('${messageJson['text']}'),
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

  /**
   * 右边消息展示
   */
  Widget meMessageChild(messageJson) {
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
                      Text('${messageJson['userId']}'),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: 50,
                      maxWidth: MediaQuery.of(state.context!).size.width / 1.3,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: SelectableText('${messageJson['text']}'),
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
  Widget hintMessage(messageJson) {
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
                Text("${messageJson['text']}")
              ],
            ),
          ),
        ),),
      ),
    );
  }






}
