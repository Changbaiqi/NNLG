import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:nnlg/dao/AccountData.dart';
import 'package:nnlg/utils/ChitchatUtil.dart';

import 'state.dart';

class ChitChatViewLogic extends GetxController {
  final ChitChatViewState state = ChitChatViewState();

  msgListening() async {
    state.chitchatUtil.getChannel().stream.listen((event) {
      print('${event}');
      var json = jsonDecode(event);

      if (json['code'] == 200 || json['code'] == 201) {
          state.msgList.value.add({"showType":2,"text":json['msg']});
          state.msgList.refresh();
        Timer(
            Duration(milliseconds: 100),
                () => state.listScrollController.value
                .jumpTo(state.listScrollController.value.position.maxScrollExtent));
      } else if (json['code'] == 202) {
          if (json['userId'] == AccountData.studentID) {
            state.msgList.value.add(
                {"showType": 1, "userId": json['userId'], "text": json['msg']});
            state.msgList.refresh();
          }else{
            state.msgList.value.add({"showType":0,"userId":json['userId'],"text":json['msg']});
            state.msgList.refresh();
          }
        Timer(
            Duration(milliseconds: 500),
                (){state.listScrollController.value
                .jumpTo(state.listScrollController.value.position.maxScrollExtent);
            });

      } else if(json['code']== 203){
        List msgList = json['data'];

          msgList.forEach((element) {
            // print('${element}');
            if (element['userId'] == AccountData.studentID)
              state.msgList.value.insert(0,{"showType":1,"userId":element['userId'],"text":element['msg']});
            else
              state.msgList.value.insert(0,{"showType":0,"userId":element['userId'],"text":element['msg']});
            state.historyMsgNum = state.historyMsgNum == 0 || state.historyMsgNum > element['id'] ? element['id'] : state.historyMsgNum;
          });
          state.msgList.refresh();
      }


    }, onError: (error) {
      state.chitchatUtil.getChannel().sink.close();
    }, onDone: () async {
      state.chitchatUtil = ChitchatUtil();
    });
  }

  loadHistoryMessage() async {
    Map result = {
      "code": 200,
      "id": state.historyMsgNum
    };

    state.chitchatUtil.channel.sink.add(jsonEncode(result));
  }

  @override
  void onInit() {
    state.chitchatUtil = ChitchatUtil();
    msgListening();
  }

  @override
  void onClose() {
    state.chitchatUtil.close();
  }
}
