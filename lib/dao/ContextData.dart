

import 'package:flutter/cupertino.dart';

class ContextDate{

  static String ContextUrl = 'http://bwgljw.yinghuaonline.com';
  //static String VIPContextUrl = 'http://172.29.40.59:8088';
  static String VIPContextUrl = 'https://www.changbaiqi.com';
  // static String VIPContextIpPort = 'ws://172.29.40.104:8088';
  static String VIPContextIpPort = 'wss://www.changbaiqi.com';
  static String ContextCookie = '';
  static String ContextVIPTken = '';

  static ValueNotifier<int> onLineTotalCount = ValueNotifier<int>(0); //数据监听器

}