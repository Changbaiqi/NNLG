import 'dart:convert';

import 'package:web_socket_channel/io.dart';

import '../dao/AccountData.dart';
import '../dao/ContextData.dart';

class ChitchatUtil {

  late IOWebSocketChannel channel;

  ChitchatUtil(){
    channel = IOWebSocketChannel.connect(
        '${ContextDate.VIPContextIpPort}/user/chatRoom/${AccountData.studentID}');
  }


  IOWebSocketChannel getChannel(){
    return channel;
  }

  send(String msg){
    channel.sink.add(msg);
  }

  close(){
    channel.sink.close();
  }

}
