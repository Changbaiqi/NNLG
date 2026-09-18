import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:callo/dao/ContextData.dart';
import 'package:callo/dao/CustomThemeData.dart';
import 'package:callo/dao/LoginData.dart';
import 'package:callo/utils/GlassUI.dart';
import 'package:callo/utils/ShareDateUtil.dart';

import 'logic.dart';

/// 设置、账号安全及隐私：毛玻璃 + 渐变风格
class AccountSafeViewPage extends StatelessWidget {
  AccountSafeViewPage({Key? key}) : super(key: key);

  final logic = Get.find<AccountSafeViewLogic>();
  final state = Get.find<AccountSafeViewLogic>().state;

  static const String _page = 'account_safe_view';

  @override
  Widget build(BuildContext context) {
    final Color text = GlassTheme.textColor(_page);
    final Color accent = GlassTheme.accentColor(_page);
    return Obx(() => GlassBackground(
          page: _page,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              foregroundColor: text,
              iconTheme: IconThemeData(color: text),
              title: Text('设置、账号安全及隐私',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: text)),
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
              children: [
                //教务系统密码
                GlassCard(
                  page: _page,
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                  onTapDown: (v) => state.eyeState.value = true,
                  onTapUp: (v) => state.eyeState.value = false,
                  onTapCancel: () => state.eyeState.value = false,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('按住查看教务系统密码',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: text)),
                            const SizedBox(height: 6),
                            Text('您的学号：${LoginData.account}',
                                style: TextStyle(
                                    fontSize: 12.5,
                                    color: text.withValues(alpha: .55))),
                            const SizedBox(height: 2),
                            Obx(() => Text(
                                  '您的密码：${state.eyeState.value ? LoginData.password : '******'}',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: text.withValues(alpha: .55)),
                                )),
                          ],
                        ),
                      ),
                      Obx(() => Image.asset(
                            state.eyeState.value
                                ? 'assets/images/open_eye.png'
                                : 'assets/images/close_eye.png',
                            height: 18,
                            width: 18,
                            color: text.withValues(alpha: .7),
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                //极速启动
                GlassCard(
                  page: _page,
                  padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('极速启动',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: text)),
                            const SizedBox(height: 6),
                            Text(
                              '开启后先进入离线模式快速查看课表，登录认证成功后再放行其余功能',
                              style: TextStyle(
                                  fontSize: 11.5,
                                  height: 1.5,
                                  color: text.withValues(alpha: .55)),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => Switch(
                            activeColor: accent,
                            value: ContextDate.isTopSpeedStart.value,
                            onChanged: (v) {
                              ShareDateUtil().setTopSpeedStart(
                                  !ContextDate.isTopSpeedStart.value);
                            },
                          )),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                GlassSectionTitle(page: _page, title: '主题选择'),
                const SizedBox(height: 8),
                GlassCard(
                  page: _page,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('软件主题',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: text)),
                            const SizedBox(height: 4),
                            Text('选择相应的软件主题',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: text.withValues(alpha: .55))),
                          ],
                        ),
                      ),
                      _themeSwatch(
                        color: Colors.white,
                        selected: !CustomThemeData.isFollowSystemDarkMode.value &&
                            CustomThemeData.selectThemeUid.value ==
                                "default:whiteTheme",
                        onTap: () async {
                          //手动选主题时自动关闭“跟随系统”
                          if (CustomThemeData.isFollowSystemDarkMode.value) {
                            await ShareDateUtil()
                                .setIsFollowSystemDarkMode(false);
                          }
                          await ShareDateUtil()
                              .setThemeUid("default:whiteTheme")
                              .then((v) {
                            CustomThemeData.loadTheme(
                                CustomThemeData.selectThemeUid.value);
                          });
                        },
                      ),
                      const SizedBox(width: 14),
                      _themeSwatch(
                        color: const Color(0xFF1C1B20),
                        selected: !CustomThemeData.isFollowSystemDarkMode.value &&
                            CustomThemeData.selectThemeUid.value ==
                                "default:blackTheme",
                        onTap: () async {
                          //手动选主题时自动关闭“跟随系统”
                          if (CustomThemeData.isFollowSystemDarkMode.value) {
                            await ShareDateUtil()
                                .setIsFollowSystemDarkMode(false);
                          }
                          await ShareDateUtil()
                              .setThemeUid("default:blackTheme")
                              .then((v) {
                            CustomThemeData.loadTheme(
                                CustomThemeData.selectThemeUid.value);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                //跟随系统夜间模式
                GlassCard(
                  page: _page,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('跟随系统夜间模式',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: text)),
                            const SizedBox(height: 4),
                            Text('开启后跟随手机深色模式自动切换主题',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: text.withValues(alpha: .55))),
                          ],
                        ),
                      ),
                      Obx(() => Switch(
                            activeColor: accent,
                            value: CustomThemeData.isFollowSystemDarkMode.value,
                            onChanged: (v) {
                              ShareDateUtil().setIsFollowSystemDarkMode(v);
                            },
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  /// 主题色块
  Widget _themeSwatch({
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final Color accent = GlassTheme.accentColor(_page);
    final Color text = GlassTheme.textColor(_page);
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? accent : text.withValues(alpha: .15),
            width: selected ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .12),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
      ),
    );
  }
}
