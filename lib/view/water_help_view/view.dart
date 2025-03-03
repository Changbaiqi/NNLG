import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:markdown_widget/widget/markdown.dart';

import '../../dao/CustomThemeData.dart';
import '../../utils/CustomerThemeUtil.dart';
import 'logic.dart';
import 'state.dart';

class WaterHelpViewPage extends StatelessWidget {
  WaterHelpViewPage({Key? key}) : super(key: key);

  final WaterHelpViewLogic logic = Get.put(WaterHelpViewLogic());
  final WaterHelpViewState state = Get.find<WaterHelpViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('教程'),
      ),
      body: MarkdownWidget(padding:EdgeInsets.all(10),shrinkWrap: true,data: txt(),config: MarkdownConfig(configs: [
        PConfig(textStyle: TextStyle(color: CustomerThemeUtil.setColor(CustomThemeData.nowThemeData.value['chit_chat_view']!['textColor'] as List ))),
      ]),),
    );
  }

  txt(){
    return '''
### 一、绑定账号
* 1、首先需要使用微信随便扫描某个饮水机的二维码；
* 2、待页面完全加载完毕后（注意一定要加载完）点击微信右上角然后选择复制链接；
* 3、将复制好的链接粘贴到账号绑定的输入框内，然后点击“确定”按钮等待绑定成功即可。

注：绑定号账号后以后就不用再绑定账号了，软件会一直保存，除非你需要切换其他账号。
### 二、绑定饮水机冷热水
绑定饮水机的操作有两种：
* 第一种是直接点击中间的“自动探测饮水机”按钮，这种方式目前只支持桂林校区的8栋和2栋。
* 第二种是通过点击界面上的扫码按钮（“绑定”按钮）进行扫码绑定，这种每次绑定都会一直存在除非你需要换其他饮水机才需要另外扫码。
    ''';
  }
}
