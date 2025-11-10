

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContextDate{

  static const String ContextUrl = 'http://qzjw.bwgl.cn';
  //static String VIPContextUrl = 'http://192.168.1.10:8088';
  static const String VIPContextUrl = 'https://www.changbaiqi.top';
  static String ContextVIPTken = '';
  // static String VIPContextIpPort = 'ws://172.29.40.104:8088';
  static const String VIPContextIpPort = 'wss://www.changbaiqi.top';
  static String ContextCookie = '';

  static final onLineTotalCount = 0.obs; //数据监听器
  static final isTopSpeedStart = false.obs; //是否为极速启动
  static final beginnerGuidance = {}.obs; //用于新手引导的数据

}