

import 'package:flutter/cupertino.dart';

class ContextDate{

  static String ContextUrl = 'http://bwgljw.yinghuaonline.com';
  //static String VIPContextUrl = 'http://192.168.1.10:8088';
  static String VIPContextUrl = 'https://www.changbaiqi.top';
  // static String VIPContextIpPort = 'ws://172.29.40.104:8088';
  static String VIPContextIpPort = 'wss://www.changbaiqi.top';
  static String ContextCookie = '';
  static String ContextVIPTken = '';

  static ValueNotifier<int> onLineTotalCount = ValueNotifier<int>(0); //数据监听器

}