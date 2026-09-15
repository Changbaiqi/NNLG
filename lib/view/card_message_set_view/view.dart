import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/AccountData.dart';
import 'package:callo/utils/GlassUI.dart';

import 'logic.dart';

/// 卡片设置：毛玻璃 + 渐变风格
class CardMessageSetViewPage extends StatelessWidget {
  CardMessageSetViewPage({Key? key}) : super(key: key);

  final CardMessageSetViewLogic logic = Get.put(CardMessageSetViewLogic());
  final state = Get.find<CardMessageSetViewLogic>().state;

  static const String _page = 'card_message_set_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    return Obx(() => GlassBackground(
          page: _page,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: text,
              iconTheme: IconThemeData(color: text),
              title: Text('卡片设置',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: text)),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
              children: [
                //水卡绑定
                GlassCard(
                  page: _page,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  onTap: () {
                    showDialog(
                        context: context,
                        barrierColor: Colors.black.withValues(alpha: .35),
                        builder: (builder) {
                          return logic.noJustMessengerCard();
                        });
                  },
                  child: SizedBox(
                    height: 66,
                    child: Row(
                      children: [
                        _iconBox(Icons.credit_card_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('水卡绑定',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: text)),
                              const SizedBox(height: 3),
                              Text(
                                '${AccountData.justMessengerAccount.value.isEmpty ? "点击此处绑定水卡" : "当前绑定账号：${AccountData.justMessengerAccount.value}"}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: text.withValues(alpha: .55)),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: text.withValues(alpha: .30)),
                      ],
                    ),
                  ),
                ),
                //宿舍绑定
                GlassCard(
                  page: _page,
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  onTap: () {
                    logic.dormPicker();
                  },
                  child: SizedBox(
                    height: 66,
                    child: Row(
                      children: [
                        _iconBox(Icons.home_work_rounded),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('宿舍绑定',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: text)),
                              const SizedBox(height: 3),
                              Text(
                                '${logic.selectData.value.length != 3 ? "点击此处绑定宿舍" : "当前绑定宿舍：${AccountData.dormLoudongId}${AccountData.dormRoom}"}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: text.withValues(alpha: .55)),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: text.withValues(alpha: .30)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// 左侧图标块
  Widget _iconBox(IconData icon) {
    final Color accent = GlassTheme.accentColor(_page);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: accent.withValues(alpha: .12),
        border: Border.all(color: accent.withValues(alpha: .25)),
      ),
      child: Icon(icon, color: accent, size: 20),
    );
  }
}
