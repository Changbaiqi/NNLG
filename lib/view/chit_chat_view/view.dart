import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
              child:Container(
                child:  Obx(()=>SmartRefresher(
                  // enablePullUp: true,
                  enablePullDown: true,
                  header: WaterDropHeader(),
                  onRefresh: () async{
                    logic.loadHistoryMessage();
                    state.refreshController.refreshCompleted();
                  },
                  controller: state.refreshController,
                  child: ListView.builder(
                    controller: state.listScrollController.value,
                    itemCount: state.msgList.value.length,
                    padding: EdgeInsets.only(top: 27),
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredList(position: index,
                          duration: const Duration(milliseconds: 350),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: messageChild(state.msgList.value[index]),
                            ),));
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child:Container(
                      margin: EdgeInsets.fromLTRB(15, 10, 0, 10),
                      constraints: BoxConstraints(
                        maxHeight: 100.0,
                        minHeight: 50.0,
                      ),
                      decoration: BoxDecoration(
                          color:  Color(0xFFF5F6FF),
                          borderRadius: BorderRadius.all(Radius.circular(2))
                      ),
                      child: TextField(
                        controller: state.sendTextEdit,
                        cursorColor:Color(0xFF464EB5),
                        maxLines: null,
                        maxLength: 200,
                        decoration: InputDecoration(
                          counterText: '',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 16.0, right: 16.0, top: 10.0, bottom:10.0),
                          hintText: "发送",
                          hintStyle: TextStyle(
                              color: Color(0xFFADB3BA),
                              fontSize:15
                          ),
                        ),
                        style: TextStyle(
                            color: Color(0xFF03073C),
                            fontSize:15
                        ),
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
                      state.chitchatUtil.send(state.sendTextEdit.text);
                      state.sendTextEdit.text='';
                    },
                  ),
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
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
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
}
