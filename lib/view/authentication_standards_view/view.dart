import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'logic.dart';

class AuthenticationStandardsViewPage extends StatelessWidget {
  AuthenticationStandardsViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AuthenticationStandardsViewLogic>();
  final state = Get.find<AuthenticationStandardsViewLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          '认证说明',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: MarkdownWidget(padding:EdgeInsets.all(10),shrinkWrap: true, data: '''
        > 关于认证标志：
        * 黑标：最顶级的标识，代表管理员；
        * 红标：老师；
        * 蓝标：代表学校某组织成员高层；
        * 黄表：学校组织成员；
        * 绿标：荣获过学科竞赛奖（需国家级）；
        '''),
      ),
    );
  }
}
