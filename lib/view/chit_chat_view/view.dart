import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:roundcheckbox/roundcheckbox.dart';

import 'logic.dart';

/*
 * TODO
 * @Author 长白崎
 * @Date 2024/1/30 3:29
 */
class ChitChatViewPage extends StatelessWidget {
  ChitChatViewPage({Key? key}) : super(key: key);
  final logic = Get.put(ChitChatViewLogic());
  final state = Get
      .find<ChitChatViewLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    state.context = context;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          '聊天室',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            //聊天内容
            Expanded(
              flex: 1,
              child: Container(
                child: Obx(() =>
                    SmartRefresher(
                      // enablePullUp: true,
                      enablePullDown: true,
                      header: WaterDropHeader(),
                      onRefresh: () async {
                        logic.loadHistoryMessage();
                        state.refreshController.refreshCompleted();
                      },
                      controller: state.refreshController,
                      child: ListView.builder(
                        controller: state.listScrollController.value,
                        itemCount: state.msgList.value.length,
                        padding: EdgeInsets.only(top: 27),
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 350),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child:
                                  messageChild(state.msgList.value[index]),
                                ),
                              ));
                        },
                      ),
                    )),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: InkWell(
                          child: Row(
                            children: [
                              Text('Markdown'),
                              Obx(
                                    () =>
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                      child: RoundCheckBox(
                                          size: 15,
                                          checkedWidget: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                          checkedColor: Color(0xFF3C78FF),
                                          uncheckedColor: Color(0x003C78FF),
                                          border: Border.all(
                                            color: state.isMarkdown.value
                                                ? const Color(0xFF3C78FF)
                                                : const Color(0xFFD1D1D1),
                                          ),
                                          isChecked: state.isMarkdown.value,
                                          onTap: (value) {
                                            state.isMarkdown.value =
                                            !state.isMarkdown.value;
                                          }),
                                    ),
                              ),
                            ],
                          ),
                          onTap: () {
                            state.isMarkdown.value = !state.isMarkdown.value;
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
                        child: InkWell(
                          child: Row(
                            children: [
                              Text(
                                '@AI',
                                style: TextStyle(fontSize: 12),
                              ),
                              Obx(
                                    () =>
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(3, 0, 0, 0),
                                      child: RoundCheckBox(
                                          size: 15,
                                          checkedWidget: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 10,
                                          ),
                                          checkedColor: Color(0xFF3C78FF),
                                          uncheckedColor: Color(0x003C78FF),
                                          border: Border.all(
                                            color: state.isChatGLM.value
                                                ? const Color(0xFF3C78FF)
                                                : const Color(0xFFD1D1D1),
                                          ),
                                          isChecked: state.isChatGLM.value,
                                          onTap: (value) {
                                            state.isChatGLM.value =
                                            !state.isChatGLM.value;
                                          }),
                                    ),
                              )
                            ],
                          ),
                          onTap: () {
                            state.isChatGLM.value = !state.isChatGLM.value;
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                          constraints: BoxConstraints(
                            maxHeight: 100.0,
                            minHeight: 50.0,
                          ),
                          decoration: BoxDecoration(
                              color: Color(0xFFF5F6FF),
                              borderRadius:
                              BorderRadius.all(Radius.circular(2))),
                          child: TextField(
                            controller: state.sendTextEdit,
                            cursorColor: Color(0xFF464EB5),
                            decoration: InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  top: 10.0,
                                  bottom: 10.0),
                              hintText: "发送",
                              hintStyle: TextStyle(
                                  color: Color(0xFFADB3BA), fontSize: 15),
                            ),
                            style: TextStyle(
                                color: Color(0xFF03073C), fontSize: 15),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          alignment: Alignment.center,
                          height: 70,
                          child: Text(
                            '发送',
                            style: TextStyle(
                              color: Color(0xFF464EB5),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        onTap: () {
                          state.chitchatUtil.send(
                              '{"code":202,"msg": "${state.sendTextEdit
                                  .text}","data":{"type": "${state.isMarkdown
                                  .value ? "markdown" : "txt"}","ai": "${state
                                  .isChatGLM.value
                                  ? "ChatGLM"
                                  : null}","msg": "${state.sendTextEdit
                                  .text}"}}');
                          state.chitchatUtil.send(state.sendTextEdit.text);
                          state.sendTextEdit.text = '';
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /**
   * 消息展示整合
   */
  Widget messageChild(messageJson) {
    switch (messageJson['showType']) {
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
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Container(
                height: 60,
                width: 53,
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/user.jpg',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    //官方认证图标
                    Visibility(
                        visible: (messageJson['userId'] == '21060231' ||
                            messageJson['userId'] == 'AI'),
                        child: Positioned(
                            right: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                            )))
                  ],
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
                      //标识
                      Visibility(
                        visible: (messageJson['userId'] == '21060231' ||
                            messageJson['userId'] == 'AI'),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment.center,
                            height: 18,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5)),
                            child: messageJson['userId'] == '21060231'
                                ? Text(
                              '软件作者',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white),
                            )
                                : Text(
                              'AI',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Container(
                        constraints: BoxConstraints(
                          minHeight: 50,
                          maxWidth:
                          MediaQuery
                              .of(state.context!)
                              .size
                              .width / 1.3,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        // child: Padding(
                        //   padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        //   child: SelectableText('${messageJson['text']}'),
                        // ),
                        child: messageJson['type'] == "markdown"
                            ? MarkdownWidget(padding:EdgeInsets.all(10),shrinkWrap: true,data: '${messageJson['text']}')
                            : messageJson['type'] == "txt"
                            ? Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: SelectableText(
                              '${messageJson['text']}'),
                        )
                            : Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: SelectableText(
                            '消息类型错误',
                          ),
                        )),
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
    print(messageJson);
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //标识
                      Visibility(
                        visible: (messageJson['userId'] == '21060231' ||
                            messageJson['userId'] == 'AI'),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                            alignment: Alignment.center,
                            height: 18,
                            decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5)),
                            child: messageJson['userId'] == '21060231'
                                ? Text(
                              '软件作者',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white),
                            )
                                : Text(
                              'AI',
                              style: TextStyle(
                                  fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Text('${messageJson['userId']}'),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Container(
                        constraints: BoxConstraints(
                          minHeight: 50,
                          maxWidth:
                          MediaQuery
                              .of(state.context!)
                              .size
                              .width / 1.3,
                        ),
                        decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        // child: Padding(
                        //   padding: EdgeInsets.fromLTRB(10, 15, 10, 10),
                        //   child: SelectableText('${messageJson['text']}'),
                        // ),
                        child: messageJson['type'] == "markdown"
                            ? MarkdownWidget(padding: EdgeInsets.all(10),shrinkWrap: true,data: '${messageJson['text']}')
                            : messageJson['type'] == "txt"
                            ? Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: SelectableText(
                              '${messageJson['text']}'),
                        )
                            : Padding(
                          padding:
                          EdgeInsets.fromLTRB(10, 15, 10, 10),
                          child: SelectableText(
                            '消息类型错误',
                          ),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Container(
                height: 60,
                width: 53,
                child: Stack(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        'assets/images/user.jpg',
                        height: 50,
                        width: 50,
                      ),
                    ),
                    //官方认证图标
                    Visibility(
                        visible: (messageJson['userId'] == '21060231' ||
                            messageJson['userId'] == 'AI'),
                        child: Positioned(
                            left: 0,
                            bottom: 0,
                            child: Icon(
                              Icons.verified,
                              color: Colors.blueAccent,
                            )))
                  ],
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
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Container(
            constraints: BoxConstraints(minWidth: 100, minHeight: 30),
            decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("${messageJson['text']}")],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final String data='ss';
  Widget buildMarkdown() => MarkdownWidget(data: 'ss');
}
