import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:markdown_widget/markdown_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:get/get.dart';
import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 校园聊一聊（聊天室）：毛玻璃 + 渐变风格
class ChitChatViewPage extends StatelessWidget {
  ChitChatViewPage({Key? key}) : super(key: key);
  final logic = Get.put(ChitChatViewLogic());
  final state = Get.find<ChitChatViewLogic>().state;

  static const String _page = 'chit_chat_view';

  @override
  Widget build(BuildContext context) {
    state.context = context;
    final Color text = GlassTheme.textColor(_page);

    return Obx(() => GlassBackground(
          page: _page,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: text,
              iconTheme: IconThemeData(color: text),
              title: Text('聊天室',
                  style: TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w700, color: text)),
            ),
            body: Column(
              children: [
                //聊天内容
                Expanded(
                  flex: 1,
                  child: Obx(() => SmartRefresher(
                        enablePullDown: true,
                        header: const WaterDropHeader(),
                        onRefresh: () async {
                          logic.loadHistoryMessage();
                          state.refreshController.refreshCompleted();
                        },
                        controller: state.refreshController,
                        child: ListView.builder(
                          controller: state.listScrollController.value,
                          itemCount: state.msgList.value.length,
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 350),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: messageChild(
                                        state.msgList.value[index]),
                                  ),
                                ));
                          },
                        ),
                      )),
                ),
                //输入区
                _inputPanel(),
              ],
            ),
          ),
        ));
  }

  /// 底部输入区（毛玻璃面板）
  Widget _inputPanel() {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Container(
      decoration: BoxDecoration(
        color: GlassTheme.glassTint(_page)
            .withValues(alpha: GlassTheme.glassAlpha(_page)),
        border: Border(
            top: BorderSide(color: GlassTheme.border(_page), width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //功能开关
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
              child: Row(
                children: [
                  Obx(() => _toggleChip(
                        label: 'Markdown',
                        checked: state.isMarkdown.value,
                        onTap: () =>
                            state.isMarkdown.value = !state.isMarkdown.value,
                      )),
                  const SizedBox(width: 8),
                  Obx(() => _toggleChip(
                        label: '@AI',
                        checked: state.isChatGLM.value,
                        onTap: () =>
                            state.isChatGLM.value = !state.isChatGLM.value,
                      )),
                ],
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 10, 8, 10),
                    constraints: const BoxConstraints(
                      maxHeight: 100.0,
                      minHeight: 46.0,
                    ),
                    decoration: BoxDecoration(
                        color: text.withValues(alpha: .05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: text.withValues(alpha: .10), width: 1)),
                    child: TextField(
                      controller: state.sendTextEdit,
                      cursorColor: accent,
                      maxLines: null,
                      decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 14.0, right: 14.0, top: 12.0, bottom: 12.0),
                        hintText: "发送消息...",
                        hintStyle: TextStyle(
                            color: text.withValues(alpha: .45),
                            fontSize: 14),
                      ),
                      style: TextStyle(color: text, fontSize: 15),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: 76,
                    child: GradientButton(
                      text: '发送',
                      page: _page,
                      height: 42,
                      onPressed: () {
                        state.chitchatUtil.send(
                            '{"code":202,"msg": "${state.sendTextEdit.text}","data":{"type": "${state.isMarkdown.value ? "markdown" : "txt"}","ai": "${state.isChatGLM.value ? "ChatGLM" : null}","msg": "${state.sendTextEdit.text}"}}');
                        state.chitchatUtil.send(state.sendTextEdit.text);
                        state.sendTextEdit.text = '';
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 开关胶囊
  Widget _toggleChip({
    required String label,
    required bool checked,
    required VoidCallback onTap,
  }) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: checked
              ? accent.withValues(alpha: .16)
              : text.withValues(alpha: .05),
          border: Border.all(
            color: checked
                ? accent.withValues(alpha: .60)
                : text.withValues(alpha: .12),
            width: checked ? 1.3 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 14,
              color: checked ? accent : text.withValues(alpha: .45),
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: checked ? FontWeight.w700 : FontWeight.w500,
                  color: checked ? accent : text),
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

  /// 消息气泡内容
  Widget _bubbleContent(messageJson, Color text) {
    if (messageJson['type'] == "markdown") {
      return MarkdownWidget(
        padding: const EdgeInsets.all(10),
        shrinkWrap: true,
        data: '${messageJson['text']}',
        config: MarkdownConfig(configs: [
          PConfig(textStyle: TextStyle(color: text)),
        ]),
      );
    }
    if (messageJson['type'] == "txt") {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: SelectableText('${messageJson['text']}',
            style: TextStyle(
                color: text, fontSize: 14.5, height: 1.4)),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: SelectableText('消息类型错误',
          style: TextStyle(color: text)),
    );
  }

  /// 身份标签（软件作者 / AI）
  Widget _roleBadge(String userId, Color text, Color accent) {
    final bool isAuthor = userId == '21060231';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
            color: accent.withValues(alpha: .14),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: accent.withValues(alpha: .30))),
        child: Text(
          isAuthor ? '软件作者' : 'AI',
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w600, color: accent),
        ),
      ),
    );
  }

  /**
   * 左显示
   */
  Widget tpMessageChild(messageJson) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    final bool isOfficial =
        (messageJson['userId'] == '21060231' || messageJson['userId'] == 'AI');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 0, 0),
            child: SizedBox(
              height: 50,
              width: 50,
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
                      visible: isOfficial,
                      child: Positioned(
                          right: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.verified,
                            color: accent,
                            size: 18,
                          )))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${messageJson['userId']}',
                        style: TextStyle(
                            fontSize: 12,
                            color: text.withValues(alpha: .60))),
                    if (isOfficial)
                      _roleBadge('${messageJson['userId']}', text, accent),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Container(
                      constraints: BoxConstraints(
                        minHeight: 44,
                        maxWidth:
                            MediaQuery.of(state.context!).size.width / 1.3,
                      ),
                      decoration: BoxDecoration(
                          color: text.withValues(alpha: .06),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(14),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          border: Border.all(
                              color: text.withValues(alpha: .08),
                              width: 1)),
                      child: _bubbleContent(messageJson, text)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  /**
   * 右边消息展示
   */
  Widget meMessageChild(messageJson) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    final bool isOfficial =
        (messageJson['userId'] == '21060231' || messageJson['userId'] == 'AI');
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 4, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (isOfficial)
                      _roleBadge('${messageJson['userId']}', text, accent),
                    Text('${messageJson['userId']}',
                        style: TextStyle(
                            fontSize: 12,
                            color: text.withValues(alpha: .60))),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Container(
                      constraints: BoxConstraints(
                        minHeight: 44,
                        maxWidth:
                            MediaQuery.of(state.context!).size.width / 1.3,
                      ),
                      decoration: BoxDecoration(
                          color: accent.withValues(alpha: .14),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(14),
                            topRight: Radius.circular(4),
                            bottomLeft: Radius.circular(14),
                            bottomRight: Radius.circular(14),
                          ),
                          border: Border.all(
                              color: accent.withValues(alpha: .25),
                              width: 1)),
                      child: _bubbleContent(messageJson, text)),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 12, 0),
            child: SizedBox(
              height: 50,
              width: 50,
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
                      visible: isOfficial,
                      child: Positioned(
                          left: 0,
                          bottom: 0,
                          child: Icon(
                            Icons.verified,
                            color: accent,
                            size: 18,
                          )))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 提示消息
   */
  Widget hintMessage(messageJson) {
    final Color text = GlassTheme.textColor(_page);
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Container(
          constraints: const BoxConstraints(minWidth: 100, minHeight: 30),
          decoration: BoxDecoration(
              color: text.withValues(alpha: .06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: text.withValues(alpha: .10))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Text(
              "${messageJson['text']}",
              style: TextStyle(
                  fontSize: 12, color: text.withValues(alpha: .65)),
            ),
          ),
        ),
      ),
    );
  }
}
