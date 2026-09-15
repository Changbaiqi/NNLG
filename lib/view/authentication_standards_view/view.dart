import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:markdown_widget/markdown_widget.dart';

import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 认证说明：毛玻璃 + 渐变风格
class AuthenticationStandardsViewPage extends StatelessWidget {
  AuthenticationStandardsViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AuthenticationStandardsViewLogic>();
  final state = Get.find<AuthenticationStandardsViewLogic>().state;

  static const String _page = 'chit_chat_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return GlassBackground(
      page: _page,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: text,
          iconTheme: IconThemeData(color: text),
          title: Text('认证说明',
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.w700, color: text)),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
          children: [
            GlassCard(
              page: _page,
              padding: const EdgeInsets.all(6),
              child: MarkdownWidget(
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
                data: '''
        > 关于认证标志：
        * 黑标：最顶级的标识，代表管理员；
        * 红标：老师；
        * 蓝标：代表学校某组织成员高层；
        * 黄表：学校组织成员；
        * 绿标：荣获过学科竞赛奖（需国家级）；
        ''',
                config: MarkdownConfig(configs: [
                  PConfig(textStyle: TextStyle(color: text)),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
